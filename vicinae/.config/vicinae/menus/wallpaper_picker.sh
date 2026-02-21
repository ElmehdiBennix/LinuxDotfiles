#!/bin/bash

matugen image "$(find ~/Pictures/Wallpapers -type f -regextype posix-extended -iregex '.*\.(jpg|jpeg|png|gif|webp|bmp)$' | vicinae dmenu -p "Pick a Wallpaper ...")"
