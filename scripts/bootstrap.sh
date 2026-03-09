#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "$(uname)" in
  Darwin)
    if command -v brew >/dev/null 2>&1; then
      brew bundle --file="$DOTFILES_DIR/Brewfile"
    else
      echo "Homebrew is not installed."
      exit 1
    fi
    ;;
  Linux)
    echo "Linux bootstrap not set up yet."
    echo "Install packages manually for now."
    ;;
  *)
    echo "Unsupported OS."
    exit 1
    ;;
esac