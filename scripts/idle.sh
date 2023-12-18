# Enter DPMS standby after 60s idle on lockscreen
DOTS="/home/bren/dotfiles"

wayidle -t 60 ddccontrol -r 0xd6 -w 4 $1 & iPID=$!
swaylock --conf="$DOTS/sway/lock.conf"
if [ $? -eq 0 ]; then
    kill $iPID
fi