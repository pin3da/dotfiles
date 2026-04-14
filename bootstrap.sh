#!/bin/bash

install_packages() {
  ./install-packages.sh || {
    echo "Failed to install packages. Exiting."
    exit 1
  }
}

install_fonts() {
  ./install-fonts.sh || {
    echo "Failed to install fonts. Exiting."
    exit 1
  }
}

setup_configs() {
  ./setup-configs.sh || {
    echo "Failed to setup configs. Exiting."
    exit 1
  }
}

fyi_post_install() {
  echo "Remember to restart the services if needed:"

  echo "  systemctl --user restart wireplumber pipewire pipewire-pulse xdg-desktop-portal xdg-desktop-portal-wlr"

  echo "Change shell if not done yet:"
  echo "  Find path for fish 'whereis fish', then use 'chsh' to update it."
}

autoremove_packages() {
  sudo apt autoremove -y || {
    echo "Failed to autoremove packages. Exiting."
    exit 1
  }
}

main() {
  install_packages
  autoremove_packages
  install_fonts
  setup_configs
  fyi_post_install

  echo "Script completed successfully!"
}

main
