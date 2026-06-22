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
