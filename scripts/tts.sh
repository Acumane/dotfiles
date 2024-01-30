#!/bin/bash

echo key "ctrl+c" | dotool
CLIP=$(cliphist list | head -n 1 | cliphist decode)
# notify-send "$CLIP"
cliphist delete-query "$CLIP"

clean=$(perl -pe 's/(?<=\S)-\n//g' <<< "$CLIP")
clean=$(perl -pe 's/\n(?!\n)/ /g' <<< "$clean")

edge-playback --text "$TEXT" --rate=+100% --voice en-US-EricNeural
