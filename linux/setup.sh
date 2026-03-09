#!/usr/bin/env bash
set -euo pipefail

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

install_required_packages() {
  run_as_root dnf install -y \
    git curl zsh tmux fzf neovim ripgrep nodejs python3 rustup gh tree dnf-plugins-core

  if ! run_as_root dnf install -y fd-find; then
    run_as_root dnf install -y fd
  fi
}

install_optional_packages() {
  local optional_packages=(
    starship
    zoxide
    atuin
    lazygit
    bat
    eza
    watchman
    jetbrains-mono-fonts
    firefox
    vlc
  )
  local pkg

  for pkg in "${optional_packages[@]}"; do
    if run_as_root dnf install -y "${pkg}"; then
      echo "Installed optional package: ${pkg}"
    else
      echo "Skipping unavailable optional package: ${pkg}"
    fi
  done
}

install_ghostty_from_copr() {
  local repo="scottames/ghostty"

  echo "Enabling COPR repository: ${repo}"
  if ! run_as_root dnf copr enable -y "${repo}"; then
    echo "Skipping Ghostty install: could not enable COPR ${repo}"
    return
  fi

  echo "Installing Ghostty..."
  if run_as_root dnf install -y ghostty; then
    echo "Installed Ghostty from COPR."
  else
    echo "Skipping Ghostty install: package installation failed."
  fi
}

if [[ "$(uname)" != "Linux" ]]; then
  echo "linux/setup.sh can only run on Linux."
  exit 1
fi

if [[ ! -f /etc/fedora-release ]]; then
  echo "Linux setup currently supports Fedora only."
  exit 1
fi

if ! command -v dnf >/dev/null 2>&1; then
  echo "dnf is required on Fedora but is not available."
  exit 1
fi

echo "Applying Fedora-specific setup..."

echo "Installing required Fedora packages..."
install_required_packages

echo "Installing optional Fedora packages..."
install_optional_packages

install_ghostty_from_copr

if command -v zsh >/dev/null 2>&1; then
  zsh_path="$(command -v zsh)"

  if [[ "${SHELL:-}" != "${zsh_path}" ]]; then
    echo "Default shell is not zsh."
    echo "Run this command to switch:"
    echo "  chsh -s \"${zsh_path}\" \"${USER}\""
  fi
fi

echo "Fedora setup complete."
