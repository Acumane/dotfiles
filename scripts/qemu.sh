#!/bin/bash

lockfile="/tmp/qemu_window_check.lock"
class=$(echo "$1" | jq -r .class)

if [ -d "$lockfile" ]; then
    if [[ $class != qemu* ]]; then
        pid=$(cat "$lockfile/pid")
        pkill -P $pid; kill -9 $pid 2>/dev/null
        rm -rf "$lockfile"
    fi
    exit
fi

[[ $class != qemu* ]] && exit

mkdir "$lockfile" && echo $$ > "$lockfile/pid"
trap 'pkill -P $$; rm -rf "$lockfile"' EXIT

meta=false
keyd monitor | while read -r line; do
    if [[ $line == *"leftmeta down"* ]]; then meta=true
    elif [[ $line == *"leftmeta up"* ]]; then meta=false
    elif [[ "$meta" = true && $line =~ [0-9]\ down ]]; then
        num=${line:(-6):1}
        hyprctl dispatch workspace $num
    fi
done
