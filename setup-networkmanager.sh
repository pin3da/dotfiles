#!/bin/bash

rollback() {
  echo "Rolling back to old networking stack..."

  sudo systemctl disable --now NetworkManager 2>/dev/null

  # Unmask services first (required before they can be enabled)
  sudo systemctl unmask dhcpcd 2>/dev/null
  sudo systemctl unmask networking 2>/dev/null

  # Restore original interfaces file if backup exists
  if [ -f /etc/network/interfaces.backup-before-nm ]; then
    sudo cp /etc/network/interfaces.backup-before-nm /etc/network/interfaces
    echo "Restored original /etc/network/interfaces"
  fi

  # Re-enable old networking services
  sudo systemctl enable --now wpa_supplicant
  sudo systemctl enable --now networking

  echo "Rollback complete. Old networking stack restored."
}

configure_networkmanager() {
  echo "Configuring NetworkManager to manage all interfaces..."

  sudo tee /etc/NetworkManager/conf.d/10-manage-all.conf >/dev/null <<'EOF'
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

  # Stop and disable services (but not wpa_supplicant - NetworkManager needs it)
  sudo systemctl disable --now dhcpcd 2>/dev/null
  sudo systemctl disable --now networking 2>/dev/null

  # Mask services to prevent any form of activation
  # Note: Don't mask wpa_supplicant - NetworkManager uses it for WiFi scanning
  sudo systemctl mask dhcpcd 2>/dev/null
  sudo systemctl mask networking 2>/dev/null

  # Kill any running dhcpcd/old wpa_supplicant that were started outside systemd
  sudo pkill -9 dhcpcd 2>/dev/null
  # Kill interface-specific wpa_supplicant (not the D-Bus one NetworkManager uses)
  sudo pkill -f 'wpa_supplicant.*-i ' 2>/dev/null

  echo "Old services disabled and masked."
}

reset_interfaces_file() {
  echo "Reseting /etc/network/interfaces for NetworkManager..."

  # Backup original
  if [ -f /etc/network/interfaces ] && [ ! -f /etc/network/interfaces.backup-before-nm ]; then
    sudo cp /etc/network/interfaces /etc/network/interfaces.backup-before-nm
  fi

  # Replace with minimal config that only defines loopback
  # This prevents ifupdown hotplug from managing any interfaces
  sudo tee /etc/network/interfaces >/dev/null <<'EOF'
# Interfaces managed by NetworkManager - do not add entries here
# Original backed up to /etc/network/interfaces.backup-before-nm

auto lo
iface lo inet loopback
EOF

  echo "Interfaces file reset."
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

  cargo install --quiet impala-nm || {
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

  reset_interfaces_file
  disable_old_networking
  enable_networkmanager
  fyi_post_install

  echo "Script completed successfully!"
}

main "$1"
