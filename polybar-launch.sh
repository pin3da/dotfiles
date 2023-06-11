#!/usr/bin/env bash

# ~/.config/polybar/launch.sh

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch top and bottom bars
echo "---" | tee -a /tmp/poly-top.log /tmp/poly-bottom.log
polybar top 2>&1 | tee -a /tmp/poly-top.log & disown
polybar bottom 2>&1 | tee -a /tmp/poly-bottom.log & disown

echo "Bars launched..."
