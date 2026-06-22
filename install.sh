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

link() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  ln -snf "$src" "$dest"
  echo "linked $dest -> $src"
}

link "$DOTFILES/nvim" "$HOME/.config/nvim"
link "$DOTFILES/tmux" "$HOME/.config/tmux"

echo "$PROFILE" > "$HOME/.config/nvim/.profile"
echo "profile: $PROFILE"
