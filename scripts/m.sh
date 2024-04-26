#!/bin/bash

# Basic ffmpeg wrapper for common utils

cut() { # m cut <in> <range> [<out>]
  case "$3" in
    *-)  ffmpeg -i "$2" -ss "${3%-}" -c copy "${4:-$2}";;
    -*)  ffmpeg -i "$2" -to "${3#-}" -c copy "${4:-$2}";;
    *-*) start=${3%%-*}
         end=${3##*-}
         ffmpeg -i "$2" -ss "$start" -to "$end" -c copy "${4:-$2}";;
  esac
}

convert() { # m <in> to <ext>
  out="${1%.*}.$3"
  ffmpeg -i "$1" "$out" -qscale 0
}

case "$1" in
  cut) cut "$@";;
  *) if [[  "$2" =~ ^(-)?to$  ]]; then
        convert "$@"
     elif [[ $# -eq 1 ]]; then 
        ffprobe -hide_banner "$1" # m <in>
     fi;;
esac
