# Toggle (source/sink)mute and/or get status
[ "$1" = "-t" ] && pamixer $1 $2
MUTED=$(pamixer $2 --get-mute)
LED="hda-verb /dev/snd/hwC0D0"

# Source/sink: set brightness, notify
if [ "$2" = "--default-source" ]; then
    brightnessctl -d hda::micmute set $( [ $MUTED = "true" ] && echo 1 || echo 0 )
    # [ "$1" = "-t" ] && notify-send "Source $( [ $MUTED = "true" ] && echo muted || echo unmuted )"
else 
    [ $1 != "-g" ] && play -qv 0.5 $HOME/audio/sounds/active.flac &
    sudo $LED 0x20 0x500 0x0b
    [ $MUTED = "true" ] && sudo $LED 0x20 0x400 0x08 || sudo $LED 0x20 0x400 0x00
    # [ "$1" = "-t" ] && notify-send "Sink $( [ $MUTED = "true" ] && echo muted || echo unmuted )"
fi
