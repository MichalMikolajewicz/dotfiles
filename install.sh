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
