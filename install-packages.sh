#!/bin/bash

add_3p_repos() {
  echo "Adding third party repos ..."
  # Spotify
  echo 'deb [signed-by=/etc/apt/keyrings/spotify.gpg] https://repository.spotify.com stable non-free' | sudo tee /etc/apt/sources.list.d/spotify.list >/dev/null
  curl -fsSL https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/spotify.gpg >/dev/null

  # Brave
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

  # Mise
  curl -fSs https://mise.jdx.dev/gpg-key.pub | sudo tee /etc/apt/keyrings/mise-archive-keyring.pub 1>/dev/null
  echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.pub arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list >/dev/null
}

install_3p_packages() {
  echo "Installing third party packages..."
  sudo apt update -qq || {
    echo "Failed to update package lists. Exiting."
    exit 1
  }

  sudo apt install -y -qq \
    brave-browser \
    mise \
    spotify-client || {
    echo "Failed to install third party packages. Exiting."
    exit 1
  }

  rm -rf ~/.config/nvim.bak/ &&
    mv -f ~/.config/nvim{,.bak}

  git clone -q https://github.com/LazyVim/starter ~/.config/nvim &&
    rm -rf ~/.config/nvim/.git || {
    echo "Failed to clone LazyVim. Exiting."
    exit 1
  }
}

install_env_packages() {
  echo "Installing env packages..."

  mise use -g node rust || {
    echo "Failed to install environments with msise. Exiting."
    exit 1
  }

  cargo install --quiet --locked --bin jj jj-cli &&
    cargo install --quiet \
      impala-nm \
      wiremix \
      bluetui || {
    echo "Failed to install packages with cargo. Exiting."
    exti 1
  }
}

install_apt_packages() {
  echo "Installing required packages..."
  sudo apt update -qq || {
    echo "Failed to update package lists. Exiting."
    exit 1
  }

  sudo apt install -y -qq \
    sway swaylock waybar swaybg sway-notification-center swayidle wofi \
    dunst \
    brightnessctl \
    pulseaudio-utils \
    playerctl gir1.2-playerctl-2.0 python3-gi \
    kanshi \
    wl-clipboard \
    foot \
    fish \
    build-essential \
    git \
    btop \
    curl \
    chromium \
    tree \
    intel-gpu-tools \
    gpg \
    desktop-file-utils \
    grim slurp swappy \
    neovim luarocks jq \
    lazygit \
    clang libclang-dev \
    bluez libdbus-1-dev pkg-config \
    wavemon \
    libinput-tools \
    fastfetch \
    greetd tuigreet \
    libyaml-dev \
    alacritty \
    pipewire libpipewire-0.3-dev || {
    echo "Package installation failed. Exiting."
    exit 1
  }
}

main() {
  install_apt_packages
  add_3p_repos
  install_3p_packages
  install_env_packages

  echo "Packages installed successfully!"
}

main
