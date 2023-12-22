# Enter DPMS standby after 60s idle on lockscreen
DOTS="/home/bren/dotfiles"
exec &> /dev/null

# User-activated (-f): force standby in 2s
if [ "$2" = "-f" ]; then
    swaylock --conf="$DOTS/sway/lock.conf" --grace=0 &
    sleep 2 && ddccontrol -r 0xd6 -w 4 $1
    swayidle -w timeout 1 '' resume "ddccontrol -r 0xd6 -w 1 $1 && kill \$(pgrep -n swayidle)"
fi

wayidle -t 60 ddccontrol -r 0xd6 -w 4 $1 & iPID=$!
swaylock --conf="$DOTS/sway/lock.conf"
if [[ $? -eq 0 || $? -eq 2 ]]; then
    kill $iPID
fi
