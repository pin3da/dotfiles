#!/bin/bash

rollback() {
  echo "Rolling back to old networking stack..."

  sudo systemctl disable --now NetworkManager 2>/dev/null
  sudo systemctl enable --now wpa_supplicant
  sudo systemctl enable --now networking

  echo "Rollback complete. Old networking stack restored."
}

configure_networkmanager() {
  echo "Configuring NetworkManager to manage all interfaces..."

  sudo tee /etc/NetworkManager/conf.d/10-manage-all.conf > /dev/null << 'EOF'
[ifupdown]
managed=true
EOF
}

install_networkmanager() {
  echo "Installing NetworkManager..."
  sudo apt update || {
    echo "Failed to update package lists. Exiting."
    exit 1
  }

  sudo apt install -y network-manager || {
    echo "Failed to install NetworkManager. Exiting."
    exit 1
  }
}

disable_old_networking() {
  echo "Disabling old networking services..."

  sudo systemctl disable --now wpa_supplicant 2>/dev/null
  sudo systemctl disable --now dhcpcd 2>/dev/null
  sudo systemctl disable --now networking 2>/dev/null

  echo "Old services disabled."
}

enable_networkmanager() {
  echo "Enabling NetworkManager..."

  sudo systemctl enable --now NetworkManager || {
    echo "Failed to enable NetworkManager. Exiting."
    exit 1
  }
}

install_impala() {
  echo "Installing impala-nm..."

  cargo install impala-nm || {
    echo "Failed to install impala. Exiting."
    exit 1
  }
}

fyi_post_install() {
  echo ""
  echo "Setup complete! Connect to WiFi with:"
  echo "  impala-nm"
  echo "  # or"
  echo "  nmcli device wifi connect 'SSID' password 'PASSWORD'"
}

main() {
  if [ "$1" = "--rollback" ]; then
    rollback
    exit 0
  fi

  install_networkmanager
  install_impala
  configure_networkmanager

  disable_old_networking
  enable_networkmanager
  fyi_post_install

  echo "Script completed successfully!"
}

main "$1"
