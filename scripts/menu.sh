#!/bin/bash

pkill -x rofi

case $1 in
    "run")   rofi -show drun -show-icons;;
    "copy")  cliphist list | rofi -dmenu -display-columns 2 -p "" -theme-str "listview{lines:6;columns:1;} window{width:375px;}" | cliphist decode | wl-copy;;
    "emoji") rofimoji --action clipboard --selector-args="-theme-str 'listview{lines:4;columns:6;fixed-columns:true;flow:horizontal;} element-text{font:\"Akkurat 13\";} element{padding:11px;margin:3px;}'" \
            --hidden-descriptions -s neutral --max-recent 0 -r '';;
esac
