#!/bin/bash

install_fonts() {
  echo "Installing fonts..."

  FONT_DIR="$HOME/.local/share/fonts"
  FONT_URL="https://github.com/ryanoasis/nerd-fonts/raw/refs/heads/master/patched-fonts/RobotoMono/Regular/RobotoMonoNerdFontMono-Regular.ttf"

  mkdir -p "$FONT_DIR"

  curl -fsSL "$FONT_URL" \
    -o "$FONT_DIR/RobotoMonoNerdFontMono-Regular.ttf" || {
    echo "Failed to download font. Exiting."
    exit 1
  }

  fc-cache -f
}

main() {
  install_fonts

  echo "Fonts installed successfully!"
}

main
