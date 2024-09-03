SWAP=("capslock = overload(control, esc)" "capslock = C-")
GAME=$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
KEYD="$HOME/dotfiles/keyd/global.conf"
# -k          keys-only mode
# -k reload   reload keys only (keyd)

if [ "$2" == "reload" ]; then
    cp "$KEYD" /etc/keyd/default.conf && keyd reload
    notify-send -u low -i - "keyd reloaded"
    exit
fi

if [[ "$GAME" = 1 ]]; then
    # ratbagctl "G900" profile active set 1
    sed -i "s/${SWAP[0]}/${SWAP[1]}/" $KEYD
    # sed -i '/^# Keys (game):/,/^$/{/^#.*:$/! s/^# //}' $KEYD
    sed -i '/^# Mouse (main):/,/^$/{/^$/!{/^#/! s/^/# /}}' $KEYD
    sed -i '/^# Disabled (game):/,/^$/{/^$/!{/^#/! s/^/# /}}' $KEYD
    cp $KEYD /etc/keyd/default.conf && keyd reload
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:blur:enabled 0"

    [[ "$1" == "-k" ]] && notify-send -i - "Keys switched to game mode" && exit

    liquidctl --match h80i set logo color fixed ff0000 --alert-threshold 75
    openrgb -p game.orp
    notify-send -u low -i - "Switched to game mode"
elif [[ "$GAME" = 0 ]]; then
    # ratbagctl "G900" profile active set 0
    sed -i "s/${SWAP[1]}/${SWAP[0]}/" $KEYD
    sed -i '/^# Mouse (main):/,/^$/{/^#.*:$/! s/^# //}' $KEYD
    # sed -i '/^# Keys (game):/,/^$/{/^$/!{/^#/! s/^/# /}}' $KEYD
    sed -i '/^# Disabled (game):/,/^$/{/^#.*:$/! s/^# //}' $KEYD
    cp $KEYD /etc/keyd/default.conf && keyd reload

    hyprctl reload
    [[ "$1" == "-k" ]] && notify-send -u low -i - "Keys switched to main mode" && exit

    liquidctl --match h80i set logo color fixed 75a6ff --alert-threshold 60
    openrgb -p main.orp
    notify-send -u low -i - "Switched to main mode"
fi
