#!/bin/zsh

[[ $(hyprctl activewindow -j | jq '.floating') = true ]] && exit
LUM=$(grim -s 0.01 -t jpeg -q 10 - | convert - -gravity Center -crop 75%\! -format "%[fx:mean]" info:)
DIM=$(bc <<< "$LUM*0.6 + 0.2")
echo $DIM

hyprctl keyword decoration:dim_around $DIM

sleep 1