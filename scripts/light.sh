#!/bin/zsh

# Normalize steps +/-(2-22)
SIZE="${1[2,-1]}"
CUR=$(brillo -G)
STEP=$((.05*$SIZE*$CUR+2))

case $1 in
    "+"*)
        brillo -A ${STEP%.*} -u 100000 ;;
    "-"*)
        brillo -U ${STEP%.*} -u 100000
esac
