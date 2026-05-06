#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt_packages=(
  build-essential
  ca-certificates
  curl
  fd-find
  file
  fzf
  git
  golang-go
  htop
  jq
  libssl-dev
  net-tools
  pkg-config
  ripgrep
  unzip
  vim
)

apt-get update
apt-get install -y "${apt_packages[@]}"

apt-get autoremove -y
apt-get clean

if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  ln -sfn /usr/bin/fdfind /usr/local/bin/fd
fi

sudo -H -u vagrant bash <<'USER_TOOLS'
set -euo pipefail

export HOME=/home/vagrant
export NVM_DIR="$HOME/.nvm"

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default 'lts/*'
nvm use default
npm install --global yarn

if [ ! -x "$HOME/.bun/bin/bun" ]; then
  curl -fsSL https://bun.sh/install | bash
fi

if [ ! -x "$HOME/.cargo/bin/cargo" ]; then
  curl -fsSL https://sh.rustup.rs | sh -s -- -y
fi

. "$HOME/.cargo/env"

cargo_install_crate() {
  local crate="$1"
  cargo install --locked "$crate" || cargo install "$crate"
}

if ! command -v aichat >/dev/null 2>&1; then
  cargo_install_crate aichat
fi

if [ ! -x "$HOME/.local/bin/uv" ]; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
USER_TOOLS

