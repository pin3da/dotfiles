#!/bin/bash

# NOTE: Rofi seems broken in debian testing, should be added later

install_packages() {
  echo "Installing required packages..."
  sudo apt update || {
    echo "Failed to update package lists. Exiting."
    exit 1
  }

  sudo apt install -y \
    sway \
    dunst \
    spotify-client \
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
  # Install packages
  install_packages

  # Restart necessary services
  restart_services

  echo "Script completed successfully!"
}

main
