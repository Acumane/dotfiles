#!/bin/zsh
STORE="/tmp/effects"

load() {
    easyeffects -l $1
    echo $1 > $STORE
    play "$HOME/audio/sounds/mode.wav" &
    notify-send "Audio profile switched to ${(L)1}"
}

STATE=$(cat $STORE)

if [[ ! -f $STORE || $STATE = "Default" ]]; then
     load "Muffler"
else load "Default"
fi
