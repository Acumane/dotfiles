limbo="/tmp/limbo"
do="hyprctl dispatch"
win="hyprctl activewindow -j"

hide() {
  addr=$($win | jq -r '.address')
  [ -z $addr ] && exit
  name=$($win | jq -r '.class')
  id="$name $addr"
  [ "$name" = "Rofi" ] && { $do closewindow address:$addr; exit; }
  $do moveoutofgroup && $do movetoworkspacesilent special:limbo,address:$addr
  echo "$id" >> $limbo
  sleep 3
  grep -q "$id" $limbo || exit
  $do closewindow address:$addr
  grep -v "$id" $limbo | sponge $limbo
}

undo() {
  id=$(tail -1 $limbo); sed -i '$d' $limbo
  [ -z "$id" ] && exit

  wsID=$(hyprctl activeworkspace -j | jq '.id')
  $do movetoworkspacesilent $wsID,address:$(cut -d' ' -f2 <<< "$id")
  notify-send -u low -i - "$(cut -d' ' -f1 <<< "$id") restored"
}

([ "$1" == "-u" ] && undo) || hide
