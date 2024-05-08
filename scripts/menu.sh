x0=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .x')
y=$(hyprctl monitors -j  | jq '.[] | select(.focused == true) | .y + 450')
c=$(hyprctl monitors -j  | jq ".[] | select(.focused == true) | .width / 2 + $x0")

if ! pgrep -x rofi; then
    w=""
    case $1 in
        "run")  rofi -show drun -normal-window -show-icons & w="325";;
        "copy") w="375" && cliphist list | rofi -normal-window -dmenu -display-columns 2 -p "COPY" -theme-str "#listview{lines:6;columns:1;} #window{width:${w}px;}"\
                | cliphist decode | wl-copy & w="375";;
        "cmd")  zsh -c "$(rofi -normal-window -dmenu -p "CMD" -theme-str '#listview{enabled:false;} #entry{font:"JetBrains Mono 10";} #window{width:450px;}' &)" & w="450"
    esac
    sleep 0.1s
    pkill -USR1 waybar # show
    hyprctl dispatch "movewindowpixel exact $((c - (w/2))) $y,Rofi"

    pID=$!
    wait $pID
    pkill -USR1 waybar # hide
else
    exit
fi