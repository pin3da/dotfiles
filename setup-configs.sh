#!/bin/bash

copy_configs() {
  echo "Copying configs"

  mkdir -p ~/.config/{alacritty,jj,sway,kanshi,fish,nvim/lua/plugins}

  sudo cp ./configs/greetd.toml /etc/greetd/config.toml &&
    cp ./configs/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml &&
    cp ./configs/jj.toml ~/.config/jj/config.toml &&
    cp ./configs/kanshi ~/.config/kanshi/config &&
    cp ./configs/sway ~/.config/sway/config &&
    cp ./configs/config.fish ~/.config/fish/config.fish &&
    cp ./configs/nvim/lua/plugins/disable-completion.lua ~/.config/nvim/lua/plugins/ &&
    cp ./configs/nvim/lua/plugins/formatting.lua ~/.config/nvim/lua/plugins/ &&
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

update_backgrounds() {
  sudo mkdir -p /usr/share/backgrounds/ &&
    sudo cp ./backgrounds/berlin.png /usr/share/backgrounds/ || {
    echo "Failed to update backgrounds. Exiting."
    exit 1
  }
}

main() {
  copy_configs
  update_desktop_entries
  update_backgrounds

  echo "Configs setup completed successfully!"
}

main
