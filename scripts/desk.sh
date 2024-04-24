#!/bin/sh

handle() {
  # "desktop" mode:
  case $1 in
    "monitoradded>>DP"*)
      hyprctl keyword monitor "eDP-1, disable"
      sudo modprobe -r intel_ish_ipc
      ;;
    "monitorremoved>>DP"*)
      hyprctl keyword monitor "eDP-1, enable"
      sudo modprobe intel_ish_ipc
      ;;
  esac
}

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
