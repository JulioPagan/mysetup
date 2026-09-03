#!/usr/bin/env bash
# Symlink this repo's configs into their expected locations.
# Existing files are moved aside to <path>.backup.<timestamp> — nothing is overwritten.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"
DRY_RUN="${DRY_RUN:-0}"

link() {
  local src="$REPO/$1" dst="$2"

  if [ ! -e "$src" ]; then
    echo "skip   $dst (missing $src)"
    return
  fi

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok     $dst"
    return
  fi

  if [ "$DRY_RUN" = "1" ]; then
    echo "would  $dst -> $src"
    return
  fi

  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.backup.$STAMP"
    echo "backup $dst -> $dst.backup.$STAMP"
  fi
  ln -s "$src" "$dst"
  echo "link   $dst -> $src"
}

link ghostty/config          "$HOME/.config/ghostty/config"
link nvim                    "$HOME/.config/nvim"
link starship/starship.toml  "$HOME/.config/starship.toml"
link git/gitconfig           "$HOME/.gitconfig"
link git/ignore              "$HOME/.config/git/ignore"
link zsh/zshrc               "$HOME/.zshrc"
link zsh/zshenv              "$HOME/.zshenv"

echo
echo "Done. Next: brew bundle --file=\"$REPO/Brewfile\""
