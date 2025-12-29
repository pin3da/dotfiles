#!/bin/bash

add_3p_repos() {
  echo "Adding third party repos ..."
  echo 'deb [signed-by=/etc/apt/keyrings/spotify.gpg] https://repository.spotify.com stable non-free' | sudo tee /etc/apt/sources.list.d/spotify.list
  curl -fsSL https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/spotify.gpg > /dev/null
}

install_3p_packages() {
  echo "Installing third party packages..."
  sudo apt update || {
    echo "Failed to update package lists. Exiting."
    exit 1
  }

  sudo apt install -y \
    spotify-client || {
      echo "Failed to install third party packages. Exiting."
      exit 1
  }
}

install_packages() {
  echo "Installing required packages..."
  sudo apt update || {
    echo "Failed to update package lists. Exiting."
    exit 1
  }

  sudo apt install -y \
    sway \
    dunst \
    brightnessctl \
    pulseaudio-utils \
    playerctl \
    kanshi \
    wl-clipboard \
    foot \
    build-essential \
    waybar \
    btop \
    curl \
    gpg \
    neovim \
    clang libclang-dev \
    wofi \
    libinput-tools \
    pipewire || {
    echo "Package installation failed. Exiting."
    exit 1
  }
}

restart_services() {
  echo "Remember to restart the services if needed:"

  echo "  sudo systemctl --user restart wireplumber pipewire pipewire-pulse"
}

main() {
  install_packages
  add_3p_repos
  install_3p_packages

  # Restart necessary services
  restart_services

  echo "Script completed successfully!"
}

main
