SWAP=("capslock = overload(control, esc)" "capslock = C-")
GAME=$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
KEYD="/home/bren/dotfiles/keyd/global.conf"
if [[ $1 = "game" || ( -z "$1" && "$GAME" = 1 ) ]]; then
    # ratbagctl "G900" profile active set 1
    sed -i "s/${SWAP[0]}/${SWAP[1]}/" $KEYD
    # sed -i '/^# Mouse (game):/,/^$/{/^#.*:$/! s/^# //}' $KEYD
    sed -i '/^# Mouse (main):/,/^$/{/^$/!{/^#/! s/^/# /}}' $KEYD
    sed -i '/^# Disabled (game):/,/^$/{/^$/!{/^#/! s/^/# /}}' $KEYD
    cp $KEYD /etc/keyd/default.conf && keyd reload
    [[ -n "$1" ]] && echo "Quick switch: game" && exit

    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:blur:enabled 0"

    liquidctl --match hydro set logo color fixed ff0000
    openrgb -p game.orp
elif [[ $1 = "main" || ( -z "$1" && "$GAME" = 0 ) ]]; then
    # ratbagctl "G900" profile active set 0
    sed -i "s/${SWAP[1]}/${SWAP[0]}/" $KEYD
    sed -i '/^# Mouse (main):/,/^$/{/^#.*:$/! s/^# //}' $KEYD
    # sed -i '/^# Mouse (game):/,/^$/{/^$/!{/^#/! s/^/# /}}' $KEYD
    sed -i '/^# Disabled (game):/,/^$/{/^#.*:$/! s/^# //}' $KEYD
    cp $KEYD /etc/keyd/default.conf && keyd reload
    [[ -n "$1" ]] && echo "Quick switch: main" && exit

    hyprctl reload

    liquidctl --match hydro set logo color fixed 75a6ff
    openrgb -p main.orp
fi
