DIR="$DOTS/waybar/*"
C="$DOTS/waybar/config"
# M="$DOTS/waybar/modules.json"
S="$DOTS/waybar/style.css"

trap "killall waybar" EXIT

while true; do
	waybar -c $C -s $S &
	inotifywait -e modify $DIR
	killall waybar
done
