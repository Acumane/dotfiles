''
[global]
oneshot_timeout = 250
overload_tap_timeout = 1000
macro_sequence_timeout = 10000
layer_indicator = 1

[main]
# <C-> when chained, Esc on tap:
capslock = overload(control, esc)
# Double-tap alt(s) for forward, back
leftalt = overload(alt, oneshot(back))
rightalt = overload(altgr, oneshot(forward))
mute = timeout(mute, 600, command(sudo -iu bren effects.sh))
esc = home

# Mouse (via ratbag):
f5 = previoussong
f6 = nextsong
f9 = C-S-tab
f10 = C-tab

[back]
leftalt = overloadt(alt, A-left, 150)

[forward]
rightalt = overloadt(altgr, A-right, 150)

[control]
i = up
j = left
k = down
l = right

d = delete
u = C-z
r = C-S-z

[shift]
backspace = C-backspace

[alt]
- = —
space = ⠀

[altgr]
i = A-S-]
k = A-S-[
j = A-[
l = A-]

[meta+altgr]
i = M-S-]
k = M-S-[
j = M-[
l = M-]

# Override text selection; word navigation
[control+shift]
i = C-up
j = C-left
k = C-down
l = C-right

[control+alt] 
i = C-A-up
j = C-A-left
k = C-A-down
l = C-A-right

[meta]
f9 = M-f9
f10 = M-f10
capslock = overload(control, command(sudo -iu bren wm togglefloating))
r = C-r

# Define for app.conf:
[meta+shift]

[alt+shift]
''
