#!/bin/zsh
transform() {
  declare -A map=(
    ["normal"]=0
    ["right-up"]=3
    ["bottom-up"]=2
    ["left-up"]=1
  )
  hyprctl keyword monitor ",transform,$map[$1]"
}

monitor-sensor --accel | while read -r line; do
  if state=$(echo "$line" | rg ": ([\w-]*)" -or "\$1"); then
    echo $state
    transform $state
  fi
done
