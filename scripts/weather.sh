#!/bin/bash

cache="/tmp/weather"
now=$(date +%s)

if [ -f "$cache" ] && [ $((now - $(stat -c %Y "$cache"))) -lt 1800 ]; then
    cat "$cache" # Use cache <30m old
else
    data=$(curl -s 'wttr.in/?format=j1' 2>&1)
    [[ -z "$data" || $data =~ ^(Unknown).+ ]] && exit 1

    i=$(( $(date +%H) / 3 )) # current time block ([0-7] x 3h)
    block=".weather[0].hourly[$i]"
    cur=".current_condition[0]"
    t=$(echo "$data" | jq -r "$block.tempF")

    if [ $i -eq 7 ]; then t_soon=$(echo "$data" | jq -r '.weather[1].hourly[0].tempF')
    else t_soon=$(echo "$data" | jq -r ".weather[0].hourly[$((i + 1))].tempF"); fi

    trend=""
    if (( $(echo "$t_soon - $t >= 1" | bc -l) )); then trend="🔺"
    elif (( $(echo "$t - $t_soon >= 1" | bc -l) )); then trend="🔻"; fi

    read -r desc <<< "$(echo "$data" | jq -r "$cur.weatherDesc[0].value")"
    read -r temp wind uv <<< \
        "$(echo "$data" | jq -r "$cur | [.FeelsLikeF, .windspeedMiles, .uvIndex] | @tsv")"
    dewpt=$(echo "$data" | jq -r "$block.DewPointF") # wttr.in #738
    icon=""

    (( uv > 5 )) && icon="☀️"
    [[ $desc =~ (rain|drizzle) ]] && icon="💧"
    [[ $desc =~ ([Mm]oderate|[Hh]eavy)\ .*(rain) ]] && icon="🌧️"
    [[ $desc =~ (snow|sleet) ]] && icon="❄️"
    (( dewpt >= 65 && temp >= 80 )) && icon+="♨️"
    (( wind >= 20 )) && icon+="💨"

    echo "$temp° $trend⠀$icon" | tee "$cache"
fi 2> /dev/null | awk "{print $1}"
