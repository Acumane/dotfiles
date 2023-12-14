STATE=$(ddccontrol -r 0xd6 $2 | grep -oP '(?<=\+\/)[1245](?=\/5)')

if [[ $1 == "off" && "$STATE" == 1 ]]; then
	ddccontrol -r 0xd6 -w 4 $2
elif [[ $1 == "on" && "$STATE" == 2 ]]; then
	ddccontrol -r 0xd6 -w 1 $2
fi
