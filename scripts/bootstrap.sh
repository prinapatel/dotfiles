#!/usr/bin/env bash
# =============================================================================
# BOOTSTRAP
# sets up a fresh Mac from scratch
# usage: ./scripts/bootstrap.sh
# =============================================================================

set -e  # exit immediately if any command fails

DOTFILES="$HOME/Code/dotfiles"

echo "→ starting bootstrap..."


# =============================================================================
# HOMEBREW
# =============================================================================

if ! command -v brew &>/dev/null; then
  echo "→ installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # add homebrew to PATH for apple silicon macs
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "✓ homebrew already installed"
fi


# =============================================================================
# BREW BUNDLE
# installs everything in the Brewfile
# =============================================================================

echo "→ installing packages from Brewfile..."
brew bundle --file="$DOTFILES/Brewfile"
echo "✓ packages installed"


# =============================================================================
# UV — python version + package manager
# =============================================================================

if ! command -v uv &>/dev/null; then
  echo "→ installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
  echo "✓ uv already installed"
fi


# =============================================================================
# STOW — symlink all configs into place
# =============================================================================

echo "→ stowing dotfiles..."

cd "$DOTFILES"

for dir in nvim zsh ghostty tmux git; do
  if [ -d "$dir" ]; then
    stow --target="$HOME" "$dir"
    echo "  ✓ stowed $dir"
  else
    echo "  ✗ skipping $dir (directory not found)"
  fi
done


# =============================================================================
# GIT CONFIG
# fill in your identity after running this script
# =============================================================================

if [[ -z "$(git config --global user.name)" ]]; then
  echo ""
  echo "⚠ git identity not set. run these commands:"
  echo "  git config --global user.name \"Your Name\""
  echo "  git config --global user.email \"you@tunicpay.com\""
fi


# =============================================================================
# NEOVIM — bootstrap plugins
# opens neovim headlessly so lazy.nvim installs everything automatically
# =============================================================================

echo "→ bootstrapping neovim plugins..."
nvim --headless "+Lazy! sync" +qa
echo "✓ neovim plugins installed"


echo ""
echo "✓ bootstrap complete. restart your terminal."
