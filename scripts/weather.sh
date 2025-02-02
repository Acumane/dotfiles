#!/bin/bash

cache="/tmp/weather"
now=$(date +%s)

if [ -f "$cache" ] && [ $((now - $(stat -c %Y "$cache"))) -lt 1800 ]; then
    cat "$cache" # Use cache <30m old
else
    weather=$(curl -s 'wttr.in/?format=%f+%w+%p+%u' 2>&1)
    if [[ -z "$weather" || $weather =~ ^(Unknown).+ ]]; then
        echo "⚠️" && exit 1
    fi
    echo "$weather" \
    | sed 's/+//g;s/F//g;s/[→←↑↓]//g;s/mph//;s/mm//' \
    | tee "$cache"
# UV index, rain, wind warnings:
fi | awk '{
    temp=$1; wind=$2; precip=$3; uv=$4

    if (uv > 5) icon="☀️"
    else if (precip > 1.0) icon="💦"; else if (precip > 0) icon="💧"
    else if (wind > 20) icon="💨"

    print temp, icon
}' | awk "{print $1}"
