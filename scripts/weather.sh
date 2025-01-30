#!/bin/bash

cache="/tmp/weather"
now=$(date +%s)

if [ -f "$cache" ] && [ $((now - $(stat -c %Y "$cache"))) -lt 1800 ]; then
    cat "$cache" # Use cachce <30m old
else
    weather=$(curl -s 'wttr.in/?format=%c+%f' 2>&1)
    [[ $weather =~ ^(Unknown).+ ]] && echo "⚠️" | tee "$cache" && exit 1
    echo "$weather" | sed 's/+//g;s/F//g' | tee "$cache"
fi | awk "{print $1}"
