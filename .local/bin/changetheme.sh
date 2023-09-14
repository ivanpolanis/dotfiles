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

alacritty_dir="$HOME/.config/alacritty/"
nvim_config_file="$HOME/.config/nvim/init.lua"
tmux_dir="$HOME/.config/tmux"

# Do something based on selected option
if [ "$selected_option" == "$tokyo" ]; then
  sed -i "\$s/.*/colors = $tokyo/" "$HOME/.config/qtile/settings/pallete.py"
  sed -i '$s/.*/vim.cmd [[colorscheme tokyonight-night]]/' "$nvim_config_file"
  if [ -e $tmux_dir ]; then
    cp -f "$tmux_dir/themes/tokyonight.conf" "$tmux_dir/tmux.conf"
    tmux source "$tmux_dir/tmux.conf"
  fi
  if [ -e $alacritty_dir ]; then
    cp -f "$alacritty_dir/themes/tokyonight.yml" "$alacritty_dir/alacritty.yml"
  fi
  xdotool keydown Super keydown Ctrl key r keyup r keyup Ctrl keyup Super
elif [ "$selected_option" == "$nord" ]; then
  sed -i "\$s/.*/colors = $nord/" "$HOME/.config/qtile/settings/pallete.py"
  sed -i '$s/.*/vim.cmd [[colorscheme nord]]/' "$nvim_config_file"
  if [ -e $tmux_dir ]; then
    cp -f "$tmux_dir/themes/nord.conf" "$tmux_dir/tmux.conf"
    tmux source "$tmux_dir/tmux.conf"
  fi
  if [ -e $alacritty_dir ]; then
    cp -f "$alacritty_dir/themes/nord.yml" "$alacritty_dir/alacritty.yml"
  fi
  xdotool keydown Super keydown Ctrl key r keyup r keyup Ctrl keyup Super
else
  echo "No match"
fi
