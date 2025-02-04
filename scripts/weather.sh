#!/bin/bash

cache="/tmp/weather"
now=$(date +%s)

if [ -f "$cache" ] && [ $((now - $(stat -c %Y "$cache"))) -lt 1800 ]; then
    cat "$cache" # Use cache <30m old
else
    weather=$(curl -s 'wttr.in/?format=%f+%w+%p+%u' 2>&1 | sed 's/[^0-9. ]//g')
    [[ -z "$weather" || $weather =~ ^(Unknown).+ ]] && echo "⚠️" && exit 1

    data=$(curl -s 'wttr.in/?format=j1' 2>&1)
    cur=$(( $(date +%H) / 3 )) # current time block ([0-7] x 3h)
    now=".weather[0].hourly[$cur]"
    t=$(echo "$data" | jq -r ".weather[0].hourly[$cur].tempF")

    if [ $cur -eq 7 ]; then t_soon=$(echo "$data" | jq -r '.weather[1].hourly[0].tempF')
    else t_soon=$(echo "$data" | jq -r ".weather[0].hourly[$((cur + 1))].tempF"); fi

    trend=""
    if (( $(echo "$t_soon - $t >= 1" | bc -l) )); then trend="🔺"
    elif (( $(echo "$t - $t_soon >= 1" | bc -l) )); then trend="🔻"; fi

    read -r snow rain humid <<< \
        "$(echo "$data" | jq -r "$now | [.chanceofsnow, .chanceofrain, .humidity] | @tsv")"

    echo "$weather $rain $snow $humid $trend" | tee "$cache"
    # echo "90 30 3.0 8 51 51 84 $trend" | tee "$cache"
fi | while read temp wind precip uv rain snow humid trend; do
    icon=""
    
    (( uv > 5 )) && icon="☀️"
    (( temp > 80 && humid > 70 )) && icon+="♨️"
    (( rain > 50 )) && icon="💧"
    (( rain > 50 )) &&  [ "$(echo "$precip > 1" | bc -l)" -eq 1 ] && icon="🌧️"
    (( snow > 50 )) && icon="❄️"
    (( wind > 20 )) && icon+="💨"

    echo "$temp° $trend⠀$icon"
done | awk "{print $1}"
