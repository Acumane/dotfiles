# Enter DPMS standby after 60s idle on lockscreen
DOTS="/home/bren/dotfiles"
exec &> /dev/null

# User-activated (-f): force standby in 1.5s
if [ "$2" = "-f" ]; then
    # no x01; ddcutil's --usb can't find, hub must forget device
    ddccontrol -r 0xd6 -w 5 $1 &
    swaylock --conf="$DOTS/sway/lock.conf" --grace=0 &
    sleep .5s && brillo -O && brillo -S 0% -u 1000000 && blight set 0 &
    swayidle -w timeout 1 '' resume "brillo -I -u 150000 && kill \$(pgrep -n swayidle)"
fi
