#!/bin/sh

handle() {
  # "desktop" mode:
  case $1 in
    "monitoradded>>DP"*)
      pkill -f idle-lap.sh && pkill -f rotate.sh
      hyprctl keyword monitor "eDP-1, disable"
      sudo modprobe -r intel_ish_ipc
      # TODO: kbd *still* disables @ 360deg
      ;;
    "monitorremoved>>DP"*)
      pgrep -f "idle-lap.sh" || sh $DOTS/scripts/idle.sh &
      pgrep -f "rotate.sh" || sh $DOTS/scripts/rotate.sh &
      hyprctl keyword monitor "eDP-1, enable"
      sudo modprobe intel_ish_ipc
      ;;
  esac
}

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
