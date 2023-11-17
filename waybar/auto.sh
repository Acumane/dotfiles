C="$DOTS/waybar/config"
M="$DOTS/waybar/modules.json"
S="$DOTS/waybar/style.css"

trap "killall waybar" EXIT

while true; do
	waybar -c $C -s $S &
	inotifywait -e modify $C $M $S
	killall waybar
done
