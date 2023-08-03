pid=$(pidof rofi)
echo $1

if [ -z $pid ]; then
	if [ $1 = "run" ]; then
		rofi -show drun -normal-window &
	elif [ $1 = "cb" ]; then
		rofi -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}' -normal-window &
	fi

	pid=$(pidof rofi)
	sleep 0.5
	while [ -n $(pidof rofi) ]; do
	
	focusedpid=$(gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/WindowsExt --method org.gnome.Shell.Extensions.WindowsExt.FocusPID | sed -E "s/\\('(.*)',\\)/\\1/g")
	if [ $focusedpid -ne $pid ]; then
		break
	fi
	done
	kill $pid
else
	kill $pid
fi
