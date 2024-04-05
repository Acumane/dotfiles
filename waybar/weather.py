#!/usr/bin/env python

import json
import requests
from os import path
from datetime import datetime
from subprocess import getoutput as run

WEATHER_ICONS = {
    '113': '☀️️',
    '116': '⛅️️',
    '119': '️🌥️',
    '122': '☁️',
    '143': '🌫️',
    '176': '🌦️️',
    '179': '🌧️',
    '182': '🌧️',
    '185': '🌧️',
    '200': '⛈️',
    '227': '🌨️',
    '230': '❄️',
    '248': '🌫️',
    '260': '🌫️',
    '263': '🌦️️',
    '266': '🌦️️',
    '281': '🌧️',
    '284': '🌧️',
    '293': '🌦️️',
    '296': '🌦️️️',
    '299': '🌧️️',
    '302': '🌧️️',
    '305': '🌧️️',
    '308': '🌧️',
    '311': '🌧️',
    '314': '🌧️',
    '317': '🌧️',
    '320': '🌨️',
    '323': '🌨️',
    '326': '🌨️',
    '329': '❄️',
    '332': '❄️',
    '335': '❄️',
    '338': '❄️',
    '350': '🌧️',
    '353': '🌦️️',
    '356': '🌧️',
    '359': '🌧️',
    '362': '🌧️',
    '365': '🌧️',
    '368': '🌨️',
    '371': '❄️',
    '374': '🌧️️',
    '377': '🌧️️',
    '386': '🌩️',
    '389': '⛈️',
    '392': '⛈️',
    '395': '❄️'
}

MOON_PHASES = {
    "New Moon": "🌑",
    "Waxing Crescent": "🌒",
    "First Quarter": "🌓",
    "Waxing Gibbous": "🌔",
    "Full Moon": "🌕",
    "Waning Gibbous": "🌖",
    "Last Quarter": "🌗",
    "Waning Crescent": "🌘",
}

CHANCE_NAMES = {
    "chanceoffog": "fog",
    "chanceoffrost": "frost",
    "chanceofovercast": "overcast",
    "chanceofrain": "rain",
    "chanceofsnow": "snow",
    "chanceofsunshine": "sunshine",
    "chanceofthunder": "thunder",
    "chanceofwindy": "wind"
}

CACHE = "/tmp/wttr.json"

if path.isfile(CACHE):    
    modified = datetime.fromtimestamp(path.getmtime(CACHE))
    ago = (datetime.today() - modified).seconds
    if ago < 600:
        print(open(CACHE, "r").read()); exit()

CITY = "Berkeley"
weather = requests.get(f"https://wttr.in/{CITY}?format=j1").json()
data = {}

def formatTime(time):
    if time[-1:] == "M":
        return int(datetime.strptime(time, '%I:%M %p').strftime('%H%M'))
    else:
        return int(time[:-2]) if time[-2:] == "00" else 0

def formatChance(hour):
    chances = []
    for event in CHANCE_NAMES.keys():
        if int(hour[event]) > 0:
            chances.append(CHANCE_NAMES[event]+" "+hour[event]+"%")
    return ", ".join(chances)

def getChance(prev, cur):
    chances = []
    for event in CHANCE_NAMES.keys():
        if int(cur[event]) > 10 and int(cur[event]) - int(prev[event]) > 10:
            chances.append(cur[event]+"% "+CHANCE_NAMES[event])
    return ", ".join(chances)

cur = weather['current_condition'][0]
day = weather['weather'][0]
ast = day['astronomy'][0]

now = datetime.now().hour*100 + datetime.now().minute
sunrise = formatTime(ast['sunrise']); sunset = formatTime(ast['sunset'])
icon = WEATHER_ICONS[cur['weatherCode']]

if cur['weatherCode'] == "113": # Clear
    if now > sunset or now < sunrise: icon = MOON_PHASES[ast['moon_phase']]
data['text'] = icon+" "+cur['FeelsLikeF']+"°"

title ="font='IBM Plex Sans Bold 10.5' color='#E6E0C2'"
body ="font='IBM Plex Mono Bold 10' color='#BEB9A3'"
data['tooltip'] = f"<span {title}>{cur['weatherDesc'][0]['value']} {cur['FeelsLikeF']}°</span>\n"
data['tooltip'] += f"<span {body}>🔺{day['maxtempF']}°  🔻{day['mintempF']}°\n"
wind = cur['windspeedMiles']+'Mph'
data['tooltip'] += f"  {wind.ljust(len(wind)+1)}💨\n\n</span>"
# data['tooltip'] += f"  {(cur['humidity']+'%').ljust(len(wind)+1)}💦\n\n</span>"
data['tooltip'] += f"<span {body}>"

nowH, nowM = divmod(now, 100)
if sunset > now > sunrise:
    setH, setM = divmod(sunset, 100)
    H = setH - nowH; M = setM - nowM
    data['tooltip'] += f"🌙 in {f"{H}h" if H>0 else ''} {f"{M}m" if M>0 else ''}"
else:
    riseH, riseM = divmod(sunrise, 100)
    if riseH < nowH: riseH += 24
    H = riseH - nowH; M = riseM - nowM
    data['tooltip'] += f"☀️ in {f"{H}h" if H>0 else ''} {f"{M}m" if M>0 else ''}"


now = datetime.now().hour
prev = {}
for hour in day['hourly']:
    til = formatTime(hour['time']) - now
    if til <= 0:
        prev = hour
        continue

    # dT = int(hour['FeelsLikeF']) - int(cur['FeelsLikeF'])
    chances = getChance(prev, hour)
    data['tooltip'] += f"\n{chances} in {til}h" if chances else ""
    break

data['tooltip'] += f"</span>"

with open(CACHE, 'w') as f: json.dump(data, f)
print(json.dumps(data))
