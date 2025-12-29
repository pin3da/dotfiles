#!/bin/bash

FONT_DIR="$HOME/.local/share/fonts"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/raw/refs/heads/master/patched-fonts/RobotoMono/Regular/RobotoMonoNerdFontMono-Regular.ttf"

mkdir -p "$FONT_DIR"

curl -fL "$FONT_URL" \
  -o "$FONT_DIR/RobotoMonoNerdFontMono-Regular.ttf"

fc-cache -fv
