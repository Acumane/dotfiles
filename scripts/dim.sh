#!/bin/zsh

HIST="/tmp/last_active"

[[ -f "$HIST" && "$1" == "$(cat "$HIST")" ]] && exit
[[ $(hyprctl activewindow -j | jq '.floating') == true ]] && exit

MON=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

read X Y _X _Y <<< $(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | "\(.width) \(.height) \(.x) \(.y)"')

# -g: center 50%:
x=$(( X / 4 + _X )); y=$(( Y / 4 + _Y ))
dx=$(( X / 2 )); dy=$(( Y / 2 ))

sleep 0.25
DIM=$(grim -o "$MON" -g "${x},${y} ${dx}x${dy}" -t jpeg -q 10 - | magick - -format "%[fx:mean*0.6+0.2]" info:)

hyprctl keyword decoration:dim_around $DIM
echo "$1" > "$HIST"
