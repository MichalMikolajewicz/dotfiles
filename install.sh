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

# lazygit config path isn't XDG-consistent across platforms
if [ "$(uname)" = "Darwin" ]; then
  link "$DOTFILES/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"
else
  link "$DOTFILES/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
fi

echo "$PROFILE" > "$HOME/.config/nvim/.profile"
echo "profile: $PROFILE"

# Fetch tmux plugins (TPM + every @plugin in tmux.conf).
#
# plugins/ is gitignored, so a fresh checkout has none — and without
# vim-tmux-navigator the seamless <C-h/j/k/l> between nvim and tmux never works,
# and the gruvbox status bar never renders. Cloning them here makes the
# install truly one-shot. Idempotent: existing dirs are skipped, so re-runs are
# cheap. Prefers git; falls back to a plain tarball download (curl + tar) if
# git's smart-http protocol is blocked but HTTPS downloads aren't. tmux itself
# does not have to be installed yet.
bootstrap_tmux_plugins() {
  local plugdir="$HOME/.config/tmux/plugins"
  local conf="$HOME/.config/tmux/tmux.conf"
  mkdir -p "$plugdir"

  # Some networks (corporate proxies, locked-down devpods) block git's
  # smart-http protocol but allow plain HTTPS downloads. Fall back to grabbing
  # a tarball of the default branch via codeload — same content, no git needed.
  # Downside: no `.git`, so `prefix + U` can't update this plugin until a real
  # `git clone` succeeds (delete the dir and re-run install.sh once it does).
  fetch_tarball() { # repo (owner/name)  destdir
    local tmp
    tmp="$(mktemp -d)" || return 1
    if curl -fsSL "https://codeload.github.com/$1/tar.gz/HEAD" -o "$tmp/repo.tar.gz" \
       && mkdir -p "$2" \
       && tar -xzf "$tmp/repo.tar.gz" -C "$2" --strip-components=1; then
      rm -rf "$tmp"
      return 0
    fi
    rm -rf "$tmp" "$2"
    return 1
  }

  clone() { # repo (https URL)  destdir  name
    if [ -d "$2/.git" ] || [ -d "$2" ]; then
      echo "exists  tmux/$3"
    elif git clone --quiet --depth 1 "$1" "$2" 2>/dev/null; then
      echo "fetched tmux/$3"
    elif fetch_tarball "${1#https://github.com/}" "$2"; then
      echo "fetched tmux/$3 (tarball fallback, git blocked)"
    else
      echo "warn    failed to fetch $1 (tmux plugins incomplete)"
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
