hyprctl dispatch togglespecialworkspace 
ws=$(hyprctl monitors -j | jq -re '.[] | select(.focused == true) | .specialWorkspace.name')
c=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .width / 2 - 162')

if [ $ws == "special" ]; then
    pkill -USR1 waybar # show
    hyprctl dispatch "movewindowpixel exact $c 80,Amberol"

    case $1 in
        "run") rofi -show drun -normal-window -show-icons & ;;
        "copy") cliphist list | rofi -normal-window -dmenu -display-columns 2 -p "COPY" -yoffset 50 -theme-str "#listview{lines:6;columns:1;} #window{width:375px;}"  | cliphist decode | wl-copy & ;;
        "cmd") zsh -c "$(rofi -normal-window -dmenu -p "CMD" -yoffset -50 -theme-str '#listview{enabled:false;} #entry{font:"JetBrains Mono 10";} #window{width:450px;}' &)"
    esac
    hyprctl dispatch "focuswindow Rofi"

else 
    pkill rofi
    pkill -USR1 waybar # hide
fi
