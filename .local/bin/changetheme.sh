#!/bin/env bash

# Themes avaible
tokyo="tokyonight"
nord="nord"
catppuccin="catppuccin"
gruvbox="gruvbox"

# Get answer from user via rofi
selected_option=$(echo "$tokyo
$nord
$catppuccin
$gruvbox" | rofi -dmenu -i -p "Themes" \
  -config "~/.config/rofi/powermenu.rasi" \
  -width "10" \
  -lines 2 -line-margin 3 -line-padding 10 -scrollbar-width "0")

alacritty_dir="$HOME/.config/alacritty/"
qtile_dir="$HOME/.config/qtile"
nvim_config_file="$HOME/.config/nvim/init.lua"
tmux_dir="$HOME/.config/tmux"
wallpaper_dir="$HOME/.local/wallpapers"

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
  if [ -f "$wallpaper_dir/2.jpg" ]; then
    feh --bg-scale "$wallpaper_dir/2.jpg"
    sed -i '$s/.*/feh --bg-scale "$wallpaper_dir/2.jpg"/' "$qtile_dir/autostart.sh"
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
  if [ -f "$wallpaper_dir/nord.png" ]; then
    feh --bg-scale "$wallpaper_dir/nord.png"
    sed -i '$s/.*/feh --bg-scale "$wallpaper_dir/nord.png"/' "$qtile_dir/autostart.sh"
  fi
  xdotool keydown Super keydown Ctrl key r keyup r keyup Ctrl keyup Super
elif [ "$selected_option" == "$catppuccin" ]; then
  sed -i "\$s/.*/colors = $catppuccin/" "$HOME/.config/qtile/settings/pallete.py"
  sed -i '$s/.*/vim.cmd [[colorscheme catppuccin-mocha]]/' "$nvim_config_file"
  if [ -e $tmux_dir ]; then
    cp -f "$tmux_dir/themes/catppuccin.conf" "$tmux_dir/tmux.conf"
    tmux source "$tmux_dir/tmux.conf"
  fi
  if [ -e $alacritty_dir ]; then
    cp -f "$alacritty_dir/themes/catppuccin.yml" "$alacritty_dir/alacritty.yml"
  fi
  if [ -f "$wallpaper_dir/catppuccin.png" ]; then
    feh --bg-scale "$wallpaper_dir/catppuccin.png"
    sed -i '$s/.*/feh --bg-scale "$wallpaper_dir/catppuccin.png"/' "$qtile_dir/autostart.sh"
  fi
  xdotool keydown Super keydown Ctrl key r keyup r keyup Ctrl keyup Super
elif [ "$selected_option" == "$gruvbox" ]; then
  sed -i "\$s/.*/colors = $gruvbox/" "$HOME/.config/qtile/settings/pallete.py"
  sed -i '$s/.*/vim.cmd [[colorscheme gruvbox]]/' "$nvim_config_file"
  if [ -e $tmux_dir ]; then
    cp -f "$tmux_dir/themes/gruvbox.conf" "$tmux_dir/tmux.conf"
    tmux source "$tmux_dir/tmux.conf"
  fi
  if [ -e $alacritty_dir ]; then
    cp -f "$alacritty_dir/themes/gruvbox.yml" "$alacritty_dir/alacritty.yml"
  fi
  if [ -f "$wallpaper_dir/gruvbox.png" ]; then
    feh --bg-scale "$wallpaper_dir/gruvbox.png"
    sed -i '$s/.*/feh --bg-scale "$wallpaper_dir/gruvbox.png"/' "$qtile_dir/autostart.sh"
  fi
  xdotool keydown Super keydown Ctrl key r keyup r keyup Ctrl keyup Super
else
  echo "No match"
fi