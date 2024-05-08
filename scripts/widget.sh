#!/bin/bash

LOCK="/tmp/widget.lock" 
calc=false; music=false
move() { hyprctl dispatch "movewindowpixel exact $1 $2,$3" &> /dev/null; }
handle() {
    # Prevent widget "dance" between monitor boundaries:
    [ -e "$LOCK" ] && { [ "$1" = "mon" ] && exit || return; }
    touch "$LOCK"

    MON=$(hyprctl monitors -j | jq '.[] | select(.focused == true)')
    x0=$(echo "$MON" | jq '.x'); y0=$(echo "$MON" | jq '.y')
    w=$(echo "$MON" | jq '.width'); h=$(echo "$MON" | jq '.height')
    if [ "$1" = "Calc" ]; then
        if [ $calc == false ]; then # show
            move $((x0 + (w * 8 / 10))) $((y0 - 138)) $1
            hyprctl dispatch "focuswindow $1"
            calc=true
        else # hide
            move $((x0 + (w * 8 / 10))) $((y0 - 495)) $1
            calc=false
        fi
        sleep 0.1s # hold onto lock
    elif [ "$1" = "Amberol" ]; then
        if [ $music == false ]; then # show
            move $((x0 + (w * 8 / 10))) $((y0 + h - 342)) $1
            hyprctl dispatch "focuswindow $1"
            music=true
        else # hide
            move $((x0 + (w * 8 / 10))) $((y0 + h - 5)) $1
            music=false
        fi
        sleep 0.1s
    elif [ "$1" = "mon" ]; then # Reposition widgets
        hyprctl --batch "setprop Calc forcenoanims 1; \
        setprop Amberol forcenoanims 1"
        move $((x0 + (w * 8 / 10))) $((y0 - 495)) Calc
        move $((x0 + (w * 8 / 10))) $((y0 + h - 5)) Amberol
        sleep 0.1s
        hyprctl --batch "setprop Calc forcenoanims 0; \
        setprop Amberol forcenoanims 0"
    fi
    rm -f "$LOCK"
}

# TODO: hover, pos %, obscure Hyprland crash >:(
[ "$1" = "mon" ] && handle "$1" && exit

gnome-calculator &
flatpak run io.bassi.Amberol &
sleep 2s; handle "mon" # init

trap 'rm -f "$LOCK_FILE" && exit' INT TERM EXIT
trap 'handle "Amberol"' USR1
trap 'handle "Calc"' USR2

while :; do wait; done
