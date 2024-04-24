if ! pgrep -x rofi; then
    pkill -USR1 waybar # show
    case $1 in
        "run") rofi -show drun -normal-window -show-icons & ;;
        "copy") cliphist list | rofi -normal-window -dmenu -display-columns 2 -p "COPY" -theme-str "#listview{lines:6;columns:1;}" | cliphist decode | wl-copy & ;;
        "cmd") zsh -c "$(rofi -normal-window -dmenu -p "CMD" -theme-str '#listview{enabled:false;} #entry{font:"JetBrains Mono 10";} #window{width:450px;}' &)"
    esac

else exit
fi

# Monitor rofi process and exit if it's not running
while pgrep -x rofi; do
    sleep 0.2s
done

pkill -USR1 waybar # hide
