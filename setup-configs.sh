#!/bin/bash

copy_configs() {
  echo "Copying configs"

  mkdir -p ~/.config/{jj,sway,kanshi,fish}

  sudo cp ./configs/greetd.toml /etc/greetd/config.toml &&
    cp ./configs/jj.toml ~/.config/jj/config.toml &&
    cp ./configs/kanshi ~/.config/kanshi/config &&
    cp ./configs/sway ~/.config/sway/config &&
    cp ./configs/config.fish ~/.config/fish/config.fish &&
    cp -rf ./configs/waybar ~/.config/ || {
    echo "Failed to copy configs. Exiting."
    exit 1
  }
}

update_desktop_entries() {
  cp ./applications/spotify.desktop ~/.local/share/applications/spotify.desktop &&
    chmod +x ~/.local/share/applications/spotify.desktop &&
    update-desktop-database ~/.local/share/applications >/dev/null 2>&1 || {
    echo "Failed to update desktop entries. Exiting."
    exit 1
  }
}

main() {
  copy_configs
  update_desktop_entries

  echo "Configs setup completed successfully!"
}

main
