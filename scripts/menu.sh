#!/bin/bash

pgrep -x rofi && exit

case $1 in
    "run")  rofi -show drun -show-icons;;
    "copy") w="375" && cliphist list | rofi -dmenu -display-columns 2 -p "" -theme-str "listview{lines:6;columns:1;} window{width:${w}px;}" | cliphist decode | wl-copy;;
    "emoji") rofimoji --action clipboard --selector-args="-theme-str 'listview{lines:4;columns:6;fixed-columns:true;flow:horizontal;} element-text{font:\"Akkurat 13\";} element{padding:11px;margin:3px;}'" \
            --hidden-descriptions -s neutral --max-recent 0 -r '';;
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
