#!/bin/bash

add_3p_repos() {
  echo "Adding third party repos ..."
  echo 'deb [signed-by=/etc/apt/keyrings/spotify.gpg] https://repository.spotify.com stable non-free' | sudo tee /etc/apt/sources.list.d/spotify.list
  curl -fsSL https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/spotify.gpg >/dev/null

  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
}

install_3p_packages() {
  echo "Installing third party packages..."
  sudo apt update || {
    echo "Failed to update package lists. Exiting."
    exit 1
  }

  sudo apt install -y \
    brave-browser \
    spotify-client || {
    echo "Failed to install third party packages. Exiting."
    exit 1
  }

  rm -rf ~/.config/nvim.bak/ &&
    mv -f ~/.config/nvim{,.bak} &&
    git clone https://github.com/LazyVim/starter ~/.config/nvim &&
    rm -rf ~/.config/nvim/.git || {
    echo "Failed to clone LazyVim. Exiting."
    exit 1
  }
}

copy_configs() {
  echo "Copying configs"

  mkdir -p ~/.config/{jj,sway,kanshi}

  sudo cp ./configs/greetd.toml /etc/greetd/config.toml &&
    cp ./configs/jj.toml ~/.config/jj/config.toml &&
    cp ./configs/kanshi ~/.config/kanshi/config &&
    cp ./configs/sway ~/.config/sway/config &&
    cp -r ./configs/waybar ~/.config/waybar || {
    echo "Failed to copy configs. Exiting."
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
    sway swaylock waybar swaybg sway-notification-center swayidle wofi \
    dunst \
    brightnessctl \
    pulseaudio-utils \
    playerctl \
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
    gpg \
    neovim luarocks \
    lazygit \
    clang libclang-dev \
    libinput-tools \
    greetd tuigreet \
    alacritty \
    pipewire || {
    echo "Package installation failed. Exiting."
    exit 1
  }
}

fyi_post_install() {
  echo "Remember to restart the services if needed:"

  echo "  sudo systemctl --user restart wireplumber pipewire pipewire-pulse"

  echo "Change shell if not done yet:"
  echo "  Find path for fish 'whereis fish', then use 'chsh' to update it."
}

main() {
  install_packages
  add_3p_repos
  install_3p_packages
  copy_configs
  fyi_post_install

  echo "Script completed successfully!"
}

main
