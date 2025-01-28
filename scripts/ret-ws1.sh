#!/bin/bash

ws=$(echo "$1" | jq -r '.workspace.id')
n_win=$(hyprctl workspaces -j | jq -r ".[] | select(.id == $ws) | .windows")

if [ "$n_win" = "0" ] && [ "$ws" != "1" ]; then
    hyprctl dispatch workspace 1
fi
