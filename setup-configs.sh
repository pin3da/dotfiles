#!/bin/bash

# check_config warns if the destination file has lines not present in the
# repo source. This catches local edits that would be silently overwritten.
check_config() {
  local src="$1"
  local dst="$2"

  [[ -f "$dst" ]] || return 0

  # Lines present in destination but absent from source would be lost on copy.
  local lost
  lost=$(comm -13 <(sort "$src") <(sort "$dst"))

  if [[ -n "$lost" ]]; then
    echo ""
    echo "WARNING: $dst has content not present in repo source $src."
    echo "These lines would be lost:"
    echo "$lost" | sed 's/^/  /'
    read -rp "Continue anyway? [y/N] " reply
    [[ "$reply" == [yY] ]] || { echo "Aborted."; exit 1; }
  fi
}

# check_config_dir checks each file in src_dir against its counterpart in dst_dir.
check_config_dir() {
  local src_dir="$1"
  local dst_dir="$2"

  while IFS= read -r -d '' src_file; do
    local rel="${src_file#"$src_dir"/}"
    check_config "$src_file" "$dst_dir/$rel"
  done < <(find "$src_dir" -type f -print0)
}

deploy() {
  local src="$1"
  local dst="$2"
  check_config "$src" "$dst"
  cp "$src" "$dst" || { echo "Failed to copy $src -> $dst. Exiting."; exit 1; }
}

deploy_dir() {
  local src="$1"
  local dst_parent="$2"
  local dst_name
  dst_name=$(basename "$src")
  check_config_dir "$src" "$dst_parent/$dst_name"
  cp -rf "$src" "$dst_parent/" || { echo "Failed to copy $src -> $dst_parent/. Exiting."; exit 1; }
}

copy_configs() {
  echo "Copying configs"

  mkdir -p ~/.config/{alacritty,jj,sway,kanshi,fish,nvim/lua/plugins,git/hooks,wofi,tmux}

  check_config ./configs/greetd.toml /etc/greetd/config.toml
  sudo cp ./configs/greetd.toml /etc/greetd/config.toml || { echo "Failed to copy greetd config. Exiting."; exit 1; }

  deploy ./configs/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
  deploy ./configs/jj.toml ~/.config/jj/config.toml
  deploy ./configs/kanshi ~/.config/kanshi/config
  deploy ./configs/sway ~/.config/sway/config
  deploy ./configs/config.fish ~/.config/fish/config.fish
  deploy_dir ./configs/nvim/lua/plugins ~/.config/nvim/lua
  deploy ./configs/git/hooks/pre-push ~/.config/git/hooks/pre-push
  chmod +x ~/.config/git/hooks/pre-push
  deploy_dir ./configs/wofi ~/.config
  deploy_dir ./configs/waybar ~/.config
  deploy ./configs/tmux.conf ~/.config/tmux/tmux.conf

  git config --global core.hooksPath ~/.config/git/hooks
  echo "Global git hooks configured at ~/.config/git/hooks"
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
