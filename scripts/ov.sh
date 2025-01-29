#!/bin/bash

meta=false; overview=false; shift=false

keyd monitor | while read -r line; do
    if [[ $line == *"leftmeta up"* ]]; then
        if [ "$overview" = true ]; then
            pkill -USR1 waybar # hide
            hyprctl reload
            overview=false
        fi
        meta=false
    elif [[ $line == *"leftmeta down"* ]]; then meta=true

    elif [[ $line == *"shift down"* ]];    then shift=true
    elif [[ $line == *"shift up"* ]];      then shift=false
        
    elif [[ $line == *"tab down"* ]] && [ "$meta" = true ]; then
        if [ "$overview" = false ]; then
            overview=true
            pkill -USR1 waybar # show
            hyprctl --batch "keyword general:gaps_in 16; keyword general:gaps_out 64"
        else # repeat tab
            if [ "$shift" = true ]; then hyprctl dispatch cyclenext prev
            else hyprctl dispatch cyclenext
            fi
        fi
    fi
done
