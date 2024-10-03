#!/bin/bash

echo key "ctrl+c" | dotool
CLIP=$(cliphist list | head -n 1 | cliphist decode)
cliphist delete-query "$CLIP"

# EOL: hyphenation, linebreaks
TEXT=$(perl -pe 's/(?<=\S)-\n//g' <<< "$CLIP")
TEXT=$(perl -pe 's/\n(?!\n)/ /g' <<< "$TEXT")

spd-say -o piper -r +25 "$TEXT"
