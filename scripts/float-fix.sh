#!/bin/bash

read -r addr class floats w h <<< \
    "$(echo "$1" | jq -r '[.address, .class, .floating, .size[0], .size[1]] | @tsv')"

if [[ "$class" =~ (Nautilus)$ && "$floats" = "true" ]]; then
    # decrypt auth window (no title); Nautilus CSD corner fix
    [[ $w -eq 662 && $h -eq 305 ]] && hyprctl "dispatch setprop address:$addr rounding 10"
fi

if [[ "$class" =~ (firefox)$ ]]; then for _ in {1..64}; do
    sleep 0.08

    title=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$addr\") | .title")

    if [[ "$title" =~ ^(Extension|(Sign|Log) [Ii]n) ]]; then
        pos=$(hyprctl cursorpos | tr -d ',')
        hyprctl --batch "dispatch focuscurrentorlast; \
                         dispatch setfloating address:$addr; \
                         dispatch resizewindowpixel exact 800 560, address:$addr; \
                         dispatch focuswindow address:$addr; \
                         dispatch centerwindow";
        hyprctl dispatch movecursor "$pos"
        exit 0
    fi
done; fi
