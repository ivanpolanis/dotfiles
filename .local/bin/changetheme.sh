#!/bin/env bash

# Themes avaible
tokyo="tokyonight"
nord="nord"

# Get answer from user via rofi
selected_option=$(echo "$tokyo
$nord" | rofi -dmenu -i -p "Themes" \
  -config "~/.config/rofi/powermenu.rasi" \
  -width "10" \
  -lines 2 -line-margin 3 -line-padding 10 -scrollbar-width "0")

# Do something based on selected option
if [ "$selected_option" == "$tokyo" ]; then
  sed -i "\$s/.*/colors = $tokyo/" "$HOME/.config/qtile/settings/pallete.py"
  xdotool keydown Super keydown Ctrl key r keyup r keyup Ctrl keyup Super
elif [ "$selected_option" == "$nord" ]; then
  sed -i "\$s/.*/colors = $nord/" "$HOME/.config/qtile/settings/pallete.py"
  xdotool keydown Super keydown Ctrl key r keyup r keyup Ctrl keyup Super
else
  echo "No match"
fi
