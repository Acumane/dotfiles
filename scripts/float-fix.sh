#!/bin/bash

read -r addr class floats w h <<< \
    "$(echo "$1" | jq -r '[.address, .class, .floating, .size[0], .size[1]] | @tsv')"

# Nautilus decrypt auth window (no title):
if [[ "$class" =~ (Nautilus)$ && "$floats" = "true" ]]; then # CSD corner fix:
    [[ $w -eq 662 && $h -eq 305 ]] && hyprctl "dispatch setprop address:$addr rounding 10"; exit 0
fi

# Unwanted wine windows:
title="$(echo "$1" | jq -r '.title')" # empty? (no @tsv)
if [[ "$class" =~ ((steam_app_.*)|(wineboot|explorer|.*error)\.exe)$ && "$title" = "" && "$floats" = "true"  ]]; then
    hyprctl "dispatch closewindow address:$addr"; exit 0
fi

if [[ "$class" =~ (firefox)$ ]]; then for _ in {1..64}; do
    sleep 0.08

    title=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$addr\") | .title")

    if [[ "$title" =~ (^Extension|Authorize|(Sign|Log) [Ii]n) ]]; then
        pos=$(hyprctl cursorpos | tr -d ',')
        hyprctl --batch "dispatch focuscurrentorlast; \
                         dispatch setfloating address:$addr; \
                         dispatch resizewindowpixel exact 800 560, address:$addr; \
                         dispatch focuswindow address:$addr; \
                         dispatch centerwindow";
        hyprctl dispatch movecursor "$pos"; exit 0
    fi
done; fi
