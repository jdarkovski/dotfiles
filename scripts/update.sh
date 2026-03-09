#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZSH_DIR="${ZSH:-${HOME}/.oh-my-zsh}"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-${ZSH_DIR}/custom}"

run_as_root() {
  if [[ "${EUID}" -eq 0 ]]; then
    "$@"
    return
  fi

  if command -v sudo >/dev/null 2>&1; then
    sudo "$@"
    return
  fi

  echo "This command needs root privileges, but sudo is unavailable."
  exit 1
}

update_macos() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is not installed."
    exit 1
  fi

  echo "Updating Homebrew metadata..."
  brew update

  echo "Applying Brewfile..."
  brew bundle --file="${DOTFILES_DIR}/Brewfile"
}

update_fedora() {
  if ! command -v dnf >/dev/null 2>&1; then
    echo "dnf is required on Fedora but is not available."
    exit 1
  fi

  echo "Upgrading Fedora packages..."
  run_as_root dnf upgrade --refresh -y
}

update_git_repo() {
  local repo_dir="$1"
  local label="$2"

  if [[ ! -d "${repo_dir}/.git" ]]; then
    echo "Skipping ${label}: not installed as a git checkout."
    return
  fi

  echo "Updating ${label}..."
  git -C "${repo_dir}" pull --ff-only
}

update_shell_stack() {
  if ! command -v git >/dev/null 2>&1; then
    echo "Skipping Oh My Zsh/plugin updates: git is unavailable."
    return
  fi

  update_git_repo "${ZSH_DIR}" "oh-my-zsh"
  update_git_repo "${ZSH_CUSTOM_DIR}/plugins/zsh-autocomplete" "zsh-autocomplete"
  update_git_repo "${ZSH_CUSTOM_DIR}/plugins/zsh-autosuggestions" "zsh-autosuggestions"
  update_git_repo "${ZSH_CUSTOM_DIR}/plugins/zsh-history-substring-search" "zsh-history-substring-search"
  update_git_repo "${ZSH_CUSTOM_DIR}/plugins/zsh-syntax-highlighting" "zsh-syntax-highlighting"
}

update_rust_toolchain() {
  if ! command -v rustup >/dev/null 2>&1; then
    return
  fi

  echo "Updating Rust toolchain..."
  rustup update
}

case "$(uname)" in
  Darwin)
    update_macos
    ;;
  Linux)
    if [[ -f /etc/fedora-release ]]; then
      update_fedora
    else
      echo "Linux update currently supports Fedora only."
      exit 1
    fi
    ;;
  *)
    echo "Unsupported OS."
    exit 1
    ;;
esac

update_shell_stack
update_rust_toolchain

echo "Update complete."
