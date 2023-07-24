pid=$(pidof rofi)

if [ -z $pid ]; then
	rofi -show drun -normal-window &
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

