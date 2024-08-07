#!/usr/bin/env bash

xrandr --auto
[[ -f ~/.Xmodmap]] && xmodmap ~/.Xmodmap
exec i3
