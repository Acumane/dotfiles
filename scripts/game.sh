#!/bin/bash

title=$(echo "$2" | jq -r .title)
pid=$(echo "$2" | jq -r .pid)

if [[ $title =~ $1 ]]; then
    razer-cli --poll 1000
    tail --pid=$pid -f /dev/null # await close

    razer-cli --poll 500
fi
