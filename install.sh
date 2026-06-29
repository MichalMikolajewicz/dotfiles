#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
PROFILE="${1:-full}"
VALID_PROFILES="full csharp"

# validate prerequisites
if ! command -v nvim &>/dev/null; then
  echo "error: neovim is not installed"
  exit 1
fi
if ! command -v git &>/dev/null; then
  echo "error: git is not installed (needed to fetch tmux plugins)"
  exit 1
fi

# validate profile
if ! echo "$VALID_PROFILES" | grep -qw "$PROFILE"; then
  echo "error: unknown profile '$PROFILE'"
  echo "valid profiles: $VALID_PROFILES"
  exit 1
fi

# Symlink src -> dest. Anything already at dest (real dir/file, or a wrong/broken
# symlink) is moved aside to dest.bak.<timestamp> first, so re-running overrides
# cleanly with no manual cleanup. Already-correct links are left untouched.
link() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"

  # already pointing at our config? nothing to do
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok      $dest -> $src"
    return 0
  fi

  # back up whatever is in the way
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup="${dest}.bak.$(date +%Y%m%d-%H%M%S)"
    mv "$dest" "$backup"
    echo "backup  $dest -> $backup"
  fi

  ln -s "$src" "$dest"
  echo "linked  $dest -> $src"
}

link "$DOTFILES/nvim" "$HOME/.config/nvim"
link "$DOTFILES/tmux" "$HOME/.config/tmux"
link "$DOTFILES/ghostty" "$HOME/.config/ghostty"

echo "$PROFILE" > "$HOME/.config/nvim/.profile"
echo "profile: $PROFILE"

# Fetch tmux plugins (TPM + every @plugin in tmux.conf).
#
# plugins/ is gitignored, so a fresh checkout has none — and without
# vim-tmux-navigator the seamless <C-h/j/k/l> between nvim and tmux never works,
# and the catppuccin status bar never renders. Cloning them here makes the
# install truly one-shot. Idempotent: existing dirs are skipped, so re-runs are
# cheap. Needs only git; tmux itself does not have to be installed yet.
bootstrap_tmux_plugins() {
  local plugdir="$HOME/.config/tmux/plugins"
  local conf="$HOME/.config/tmux/tmux.conf"
  mkdir -p "$plugdir"

  clone() { # repo  destdir  name
    if [ -d "$2/.git" ]; then
      echo "exists  tmux/$3"
    elif git clone --quiet --depth 1 "$1" "$2"; then
      echo "fetched tmux/$3"
    else
      rm -rf "$2"                       # clean partial clone so a later run retries
      echo "warn    failed to clone $1 (tmux plugins incomplete)"
    fi
  }

  # TPM first so `prefix + I/U` (install/update) keeps working afterwards.
  clone https://github.com/tmux-plugins/tpm "$plugdir/tpm" tpm

  # then every declared plugin (TPM is handled above, skip the self-reference)
  grep -oE "@plugin ['\"][^'\"]+['\"]" "$conf" \
    | sed -E "s/@plugin ['\"]([^'\"]+)['\"].*/\1/" \
    | sort -u \
    | while IFS= read -r repo; do
        [ "$repo" = "tmux-plugins/tpm" ] && continue
        name="${repo##*/}"
        clone "https://github.com/$repo" "$plugdir/$name" "$name"
      done
}
bootstrap_tmux_plugins

# Check / install optional system tools used by Snacks.image.
#   imagemagick – converts non-PNG images (magick / convert)
#   mermaid     – renders Mermaid diagrams (mmdc)
#
# On macOS with Homebrew we install automatically if missing.
# On other platforms we just warn; install manually:
#   imagemagick: apt install imagemagick | pacman -S imagemagick | dnf install imagemagick
#   mmdc:        npm install -g @mermaid-js/mermaid-cli
check_image_tools() {
  local need_magick=0 need_mmdc=0
  command -v magick  &>/dev/null || command -v convert &>/dev/null || need_magick=1
  command -v mmdc    &>/dev/null                                    || need_mmdc=1

  if [ "$need_magick" -eq 0 ] && [ "$need_mmdc" -eq 0 ]; then
    echo "ok      imagemagick + mmdc already present"
    return 0
  fi

  if [ "$(uname)" = "Darwin" ] && command -v brew &>/dev/null; then
    [ "$need_magick" -eq 1 ] && brew install imagemagick && echo "installed imagemagick"
    [ "$need_mmdc"   -eq 1 ] && brew install mermaid    && echo "installed mermaid (mmdc)"
  else
    [ "$need_magick" -eq 1 ] && echo "warn    imagemagick not found – install it for Snacks.image (non-PNG support)"
    [ "$need_mmdc"   -eq 1 ] && echo "warn    mmdc not found – install @mermaid-js/mermaid-cli for Mermaid diagram rendering"
  fi
}
check_image_tools
