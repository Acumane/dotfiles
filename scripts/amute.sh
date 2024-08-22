# Toggle (source/sink)mute and/or get status
[ "$2" = "mic" ] && mic="--default-source"
[ "$1" = "-t" ] && pamixer $1 $mic
MUTED=$(pamixer $mic --get-mute)
LED="hda-verb /dev/snd/hwC0D0"

# Source/sink: set brightness, notify
if [ -n "$mic" ]; then
    [ $1 != "-g" ] && swayosd-client --input-volume 0
    brightnessctl -d hda::micmute set $( [ $MUTED = "true" ] && echo 1 || echo 0 )
    # [ "$1" = "-t" ] && notify-send "Source $( [ $MUTED = "true" ] && echo muted || echo unmuted )"
else 
    [ $1 != "-g" ] && swayosd-client --output-volume 0 && play -qv 0.5 $HOME/audio/sounds/active.flac &
    sudo $LED 0x20 0x500 0x0b
    [ $MUTED = "true" ] && sudo $LED 0x20 0x400 0x08 || sudo $LED 0x20 0x400 0x00
    # [ "$1" = "-t" ] && notify-send "Sink $( [ $MUTED = "true" ] && echo muted || echo unmuted )"
fi
