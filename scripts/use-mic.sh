#!/bin/bash
exec &> /dev/null

SOUND=$HOME/audio/sounds/

sleep 3
pactl subscribe | grep --line-buffered "source" | while read -r line; do
    case "$line" in
        *new*source-output*) play -v 0.1 "$SOUND/start.wav" &;;
        *remove*source-output*) play -v 0.1 "$SOUND/stop.wav" &;;
    esac
done
