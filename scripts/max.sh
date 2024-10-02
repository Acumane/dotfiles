#!/bin/bash
exec &> /dev/null

S="hyprctl dispatch scroller"
for mode in col row; do
    $S:fitsize active && $S:setmode $mode
done
