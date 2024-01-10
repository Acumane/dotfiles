BAR="/home/bren/dotfiles/waybar"
if ! pgrep -x rofi; then
    waybar -c "$BAR/config" -s "$BAR/style.css" &
    case $1 in
        "run") rofi -show drun -normal-window -show-icons & ;;
        "copy") cliphist list | rofi -normal-window -dmenu -display-columns 2 -p "COPY" -theme-str "#listview{lines:6;columns:1;}" | cliphist decode | wl-copy & ;;
        "cmd") rofi -normal-window -dmenu -p "CMD" -theme-str "#listview{enabled:false;} #window{width:450px;}" -yoffset -600 &
    esac

else exit
fi

# Monitor rofi process and exit if it's not running
while pgrep -x rofi; do
    sleep 0.2s
done

pkill waybar