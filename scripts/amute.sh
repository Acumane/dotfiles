pamixer --default-source --toggle-mute
MUTED=$(pamixer --default-source --get-mute)
# notify-send "$MUTED"

if [ $MUTED = "true" ]; then
    brightnessctl -d hda::micmute set 1
else
    brightnessctl -d hda::micmute set 0
fi