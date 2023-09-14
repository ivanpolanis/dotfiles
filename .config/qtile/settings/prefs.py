import os

mod="mod4"
alt="mod1"
terminal="alacritty"
browser="firefox"
private="librewolf"
file_manager="thunar"
code_editor="code"
launcher="rofi -show drun"
screenshot="scrot --select --line mode=edge '/tmp/%F_%T_$wx$h.png' -e 'xclip -selection clipboard -target image/png -i $f && rm $f'"
pdf_viewer="zathura"
power_menu=os.path.expanduser("~/.local/bin/powermenu.sh")
change_theme=os.path.expanduser("~/.local/bin/changetheme.sh")
