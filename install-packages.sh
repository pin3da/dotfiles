#!/bin/bash

add_3p_repos() {
  echo "Adding third party repos ..."

  # Remove legacy .list files that conflict with modernized .sources equivalents
  sudo rm -f /etc/apt/sources.list.d/spotify.list
  sudo rm -f /etc/apt/sources.list.d/mise.list

  # Spotify
  curl -fsSL https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/spotify.gpg >/dev/null
  sudo tee /etc/apt/sources.list.d/spotify.sources <<EOF >/dev/null
Types: deb
URIs: https://repository.spotify.com
Suites: stable
Components: non-free
Signed-By: /etc/apt/keyrings/spotify.gpg
EOF

  # Brave
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

  # Mise
  curl -fSs https://mise.jdx.dev/gpg-key.pub | sudo tee /etc/apt/keyrings/mise-archive-keyring.pub 1>/dev/null
  sudo tee /etc/apt/sources.list.d/mise.sources <<EOF >/dev/null
Types: deb
URIs: https://mise.jdx.dev/deb
Suites: stable
Components: main
Architectures: amd64
Signed-By: /etc/apt/keyrings/mise-archive-keyring.pub
EOF

  # Docker (testing/forky not available, using trixie stable)
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  sudo tee /etc/apt/sources.list.d/docker.sources <<EOF >/dev/null
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: trixie
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
}

install_3p_packages() {
  echo "Installing third party packages..."
  sudo apt-get update -qq >/dev/null || {
    echo "Failed to update package lists. Exiting."
    exit 1
  }

  sudo apt-get install -yqq \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    brave-browser \
    mise \
    spotify-client >/dev/null || {
    echo "Failed to install third party packages. Exiting."
    exit 1
  }

  # Add current user to docker group to run docker without sudo
  sudo usermod -aG docker "$USER"

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

  mise use -g node rust go >/dev/null || {
    echo "Failed to install environments with msise. Exiting."
    exit 1
  }

  mise exec -- go install golang.org/x/tools/cmd/goimports@latest >/dev/null || {
    echo "Failed to install goimports. Exiting."
    exit 1
  }

  mise exec -- go install golang.org/x/tools/gopls@latest >/dev/null || {
    echo "Failed to install gopls. Exiting."
    exit 1
  }

  mise exec -- npm install -g prettier >/dev/null || {
    echo "Failed to install prettier. Exiting."
    exit 1
  }

  cargo install --quiet --locked --bin jj jj-cli >/dev/null &&
    cargo install --quiet \
      impala-nm \
      wiremix \
      zoxide \
      bluetui >/dev/null || {
    echo "Failed to install packages with cargo. Exiting."
    exti 1
  }
}

install_apt_packages() {
  echo "Installing required packages..."
  sudo apt-get update -qq >/dev/null || {
    echo "Failed to update package lists. Exiting."
    exit 1
  }

  sudo apt-get install -yqq \
    sway swaylock waybar swaybg sway-notification-center swayidle wofi \
    dunst \
    brightnessctl \
    pulseaudio-utils \
    playerctl gir1.2-playerctl-2.0 python3-gi \
    kanshi \
    wayland-utils \
    wl-clipboard \
    foot \
    fish \
    build-essential \
    git \
    btop \
    curl \
    clang-format \
    chromium \
    tree \
    intel-gpu-tools \
    gpg \
    desktop-file-utils \
    grim slurp swappy \
    neovim luarocks jq ripgrep \
    lazygit \
    clang libclang-dev \
    bluez libdbus-1-dev pkg-config \
    wavemon \
    libinput-tools \
    fastfetch \
    greetd tuigreet \
    libyaml-dev \
    alacritty \
    wlsunset \
    psmisc \
    pipewire pipewire-pulse wireplumber \
    xdg-desktop-portal xdg-desktop-portal-wlr \
    libpipewire-0.3-dev libspa-0.2-bluetooth \
    tmux >/dev/null || {
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
