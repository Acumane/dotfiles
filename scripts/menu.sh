#!/bin/bash

pgrep -x rofi && exit

x0=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .x')
y=$(hyprctl monitors -j  | jq '.[] | select(.focused == true) | .y + 450')
c=$(hyprctl monitors -j  | jq ".[] | select(.focused == true) | .width / 2 + $x0")

w=""
case $1 in
    "run")  rofi -show drun -normal-window -show-icons & w="325";;
    "copy") w="375" && cliphist list | rofi -normal-window -dmenu -display-columns 2 -p "" -theme-str "listview{lines:6;columns:1;} window{width:${w}px;}" \
            | cliphist decode | wl-copy & w="375";;
    "emoji") rofimoji --selector-args="-normal-window \
            -theme-str 'listview{lines:4;columns:6;fixed-columns:true;flow:horizontal;} element-text{font:\"Akkurat 13\";} element{padding:11px;margin:3px;}'" \
            --hidden-descriptions -s neutral --max-recent 0 -r ''  & w="325";;
esac

while ! hyprctl clients | grep -q "class: Rofi"; do sleep 0.05; done

pkill -USR1 waybar

{ while pgrep -x rofi > /dev/null; do # kill if focus is lost
    if [[ $(hyprctl activewindow -j | jq -r .class) != "Rofi" ]]; then
        pkill rofi; break
    fi
    sleep 0.1
done } &

wait
pkill -USR1 waybar
