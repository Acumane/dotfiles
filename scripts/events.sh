#!/bin/sh

handle() {
  case $1 in
    # focusedmon*) sh $SCRIPTS/widget.sh mon;;

    # monitoradded*)
    #   hyprctl dispatch "focusmonitor $MONITORNAME"
    #   pkill -f idle-lap.sh && pkill -f rotate.sh && pkill -f swayidle
    #   hyprctl keyword monitor "eDP-1, disable"
    #   sudo modprobe -r intel_ish_ipc
    #   # TODO: kbd *still* disables @ 360deg
    #   pkill -USR1 waybar;;

    # monitorremoved*)
    #   hyprctl dispatch "focusmonitor eDP-1"
    #   pgrep -f "idle-lap.sh" || sh $SCRIPTS/idle.sh &
    #   pgrep -f "rotate.sh" || sh $SCRIPTS/rotate.sh &
    #   hyprctl keyword monitor "eDP-1, enable"
    #   sudo modprobe intel_ish_ipc
    #   pkill -USR1 waybar;;

    activewindowv2*)
      addr=${1#activewindowv2>>}
      pgrep "dim.sh" && : || zsh $SCRIPTS/dim.sh $addr;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
