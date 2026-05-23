#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
PROFILE="${1:-full}"

link() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  echo "linked $dest -> $src"
}

link "$DOTFILES/nvim" "$HOME/.config/nvim"

echo "$PROFILE" > "$HOME/.config/nvim/.profile"
echo "profile: $PROFILE"
