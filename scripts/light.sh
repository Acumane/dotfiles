#!/bin/zsh

# Normalize steps +/-(2-22)
CUR=$(brillo -G)
STEP=$((.2*$CUR+2))

case $1 in
    "inc" | "up"   | "++")
        brillo -A ${STEP%.*} -u 100000 ;;
    "dec" | "down" | "--")
        brillo -U ${STEP%.*} -u 100000
esac
