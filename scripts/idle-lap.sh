# Enter DPMS standby after 60s idle on lockscreen

DOTS="/home/bren/dotfiles"
exec &> /dev/null

ext_dpms_off() {
    mons=$(hyprctl monitors -j | jq -r '.[1:][].name')
    if [ -n "$mons" ]; then
        while IFS= read -r mon; do hyprctl dispatch dpms off "$mon"
        done <<< "$mons"
    fi
}

# User-activated (-f): force standby
if [ "$2" = "-f" ]; then
    swaylock --conf="$DOTS/sway/lock.conf" --grace=0 &
    sleep .5s; brillo -O; brillo -S 0% -u 1000000; blight set 0 & ext_dpms_off
    swayidle -w timeout 1 '' resume "brillo -I -u 100000 && kill \$(pgrep -n swayidle)"
    exit
fi

# Immediate (-i): lockscreen only
[ "$1" = "-i" ] && { swaylock --conf="$DOTS/sway/lock.conf" --grace=0 & exit; }

# Passive (battery): fade (50s), lock (1m30s), backlight off (1m33s), suspend (2m30s)
swayidle \
timeout 50 "(acpi -a | grep -q off) && (brillo -O; brillo -S 0% -u 3000000)" resume "pkill brillo; brillo -I -u 150000" \
timeout 90 "(acpi -a | grep -q off) && (swaylock --conf='$DOTS/sway/lock.conf' --grace-no-mouse & ext_dpms_off)" \
timeout 93 "(acpi -a | grep -q off) && blight set 0" resume "brillo -I -u 150000" \
timeout 150 "(acpi -a | grep -q off) && systemctl suspend" after-resume "brillo -I -u 150000" \
timeout 170 "(acpi -a | grep -q on) && (brillo -O; brillo -S 0% -u 3000000)" resume "pkill brillo; brillo -I -u 150000" \
timeout 210 "(acpi -a | grep -q on) && (swaylock --conf='$DOTS/sway/lock.conf' --grace-no-mouse & ext_dpms_off)" \
timeout 213 "(acpi -a | grep -q on) && blight set 0" resume "brillo -I -u 150000" \
# Passive (charging): fade (2m50s), lock (3m30s), backlight off (3m33s)
