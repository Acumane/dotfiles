# —— ALIASES ————————————————————

alias reload="exec zsh"
alias bundle="antigen bundle"
alias using="antigen use"
alias load="zcomet load"
alias sudo="\sudo -E env PATH=$PATH "
alias dots="dotfiles"

alias color="grc -es"
alias l="eza --icons -F "; alias ls="l"
alias la="eza --icons -AF -s modified"
alias ld="eza --icons -AF -lm -T --level=1 --time-style=relative"
alias bu="rsync -avuP"
alias cp="cp -r"
alias del="sudo \rm -rf"
wipe() {
  local src=$([[ "$2" =~ ^(-r|--random)$ ]] && echo urandom)
  sudo dd if=/dev/${src:-zero} of=$1 bs=1M status=progress; }
alias shred="shred -u" # OR scrub
alias rm="trash-put"
alias toss="trash-put"
alias trash="trash-list"
alias restore="trash-restore"
alias dump="trash-empty --all-users -f"
alias rn="mv"
mk() {
  [[ "${1: -1}" == "/" ]] && mkdir -p "${1:0:-1}" \
  || touch "$1"
}
alias mkd="mkdir -p"
alias watch="entr -pc"
alias first="head -n 1" 
alias last="tail -n 1"
sys() { [ $# -eq 0 ] && sysz && return
  systemctl "${@: -1}" 2> >(grep -q "Unknown command verb") && systemctl "$@" || sysz "$@"; }
alias log="journalctl -p 0..4 -b"
diag() { sudo dmesg -T --color=always "$@" | less -FSXK; }
alias dmesg="diag"
alias vigil="vigiland"
alias reboot="sudo reboot"
alias shutdown="sudo shutdown now"
alias suspend="systemctl suspend"
alias hibernate="$DOTS/scripts/idle-lap.sh -i && /bin/systemctl hibernate"
alias off="hibernate"; alias hiber="hibernate"
alias logout="hyprctl dispatch exit"
alias lock="$DOTS/scripts/idle-lap.sh -f"
bios() {
  case "${(L)1}" in
    -v) sudo dmidecode -q -t bios | grep -E "Version|Revision" | \
          tr -d "\t";;
    *) sudo systemctl reboot --firmware-setup
  esac
}

alias tar="tar -czvf"
untar() { \tar -xvf "$1" --one-top-level="$2"; }
zip() { command zip -r "$1.zip" "$1"/; }
# unzip
alias calc="bc"
alias ping="grc ping -c 5"
alias root="\sudo -s"
alias auth="pkexec"
alias kernel="uname -r"
alias about="hostnamectl | grep -E '(Operating|Model|Kernel)' | sed 's/^ *//' \
&& [ $DEV_TYPE = "lap" ] && sudo dmidecode -q -t System | grep 'Serial' | tr -d '\t'"
alias uptime="uptime -p"
alias hw="hwinfo --short"
alias user="echo $USER"
alias name="echo $(hostname)/$(echo $USER)"
alias ports='grc netstat -tulanp'
alias sockets='grc netstat -xlanp'
alias mac="ifconfig | grep ether | awk '{print \$2}'"
ip() {
  case "${(L)1}" in
    pub|public) curl -s "http://ifconfig.me";;
    *) command ip -br -c addr | grep -vE "br-|docker";;
  esac
}

phone() {
case $1 in
  audio | -a) scrcpy --no-video --no-window -w --start-app=\?Spotify "${@:2}" &> /dev/null;;
  # scrcpy --video-source=camera --no-audio --camera-facing=front --v4l2-sink=/dev/video0 --orientation=270
  *) scrcpy -w "$@" 2> /dev/null;; esac; }
alias ph="phone"
alias cam="v4l2-ctl"
vm() { cur=$(pwd);
cd "$HOME/VMs" && quickemu --vm $1.conf ${@:2} && cd "$cur"; }
spin() { cur=$(pwd);
cd "$HOME/.local/share/$1" && docker compose ${@:2} && cd "$cur"; }
key() {
case $1 in
  reload) sudo cp $DOTS/keyd/global.conf /etc/keyd/default.conf && keyd reload;;
  *) keyd "$@";; esac; }
alias clock="while true; do clear; date '+%b %-d, %-I:%M:%S %p'; sleep 1; done"
alias quote="curl -s 'https://zenquotes.io/api/random' | jq -r '.[0].q'"
# alias quote="curl -s 'https://api.realinspire.tech/v1/quotes/random' | jq -r '.[0].content'"

tz() {
  local TZ
  if [ -z "$1" ]
  then TZ=$(curl -s http://ip-api.com/json | jq -r '.timezone')
  else TZ=$(timedatectl list-timezones | grep -i "$1" | head -n 1); fi
  [ -n "$TZ" ] && timedatectl set-timezone "$TZ"
  date
}
alias loc="curl -s http://ip-api.com/json | jq -r '.city + \", \" + .region + \" \" + .zip'"
vault() { setopt LOCAL_OPTIONS NO_MONITOR
  output=$(flatpak run io.github.mpobaschnig.Vaults -o "$1" 2>&1)
  [[ $output == *"Opened vault successfully"* ]] && cd ~/"$1" && nautilus ~/"$1" 2>/dev/null; }
# vault() { gocryptfs -allow_other -q -i 30m -- "$HOME/.enc/$1" "$HOME/$1"; }
alias vpn="mullvad"
net() {
  case "${(L)1}" in
    pass)
      ssid=$(nmcli -t -f NAME connection show --active | head -n 1)
      nmcli -s -g 802-11-wireless-security.psk connection show "${2:-$ssid}";;
    speed) fast -u --single-line;;
    type) nmcli -t -f TYPE,STATE device status | grep ":connected$" | head -n 1 | cut -d':' -f1;;
    scan) nmcli dev wifi rescan && nmcli dev wifi list;;
    *) nmcli dev wifi ${@:1}
  esac
}
alias udev="udevadm"
mic() {
  pactl load-module module-loopback 1> /dev/null
  trap "pactl unload-module module-loopback" EXIT INT TERM
  sleep infinity
}

dl() {
  case "${(L)1}" in
    video | -v) yt-dlp -P "$DL" -N 4 "$2";;
    audio | -a) yt-dlp -P "$DL" -x -N 4 "$2";;
    *) wget -N -P "$DL" "$1"
  esac
}
push() { tailscale file cp "$1:"; }
alias pull="sudo tailscale file get"

alias pn="pnpm"
alias py="python"
app() {
  case $1 in
    repo) shift
    case $1 in
      add) dnf config-manager addrepo --from-repofile="$2";;
      *) dnf config-manager setopt $1.${2#--};;
    esac;;
    cleanup) sudo dnf autoremove;;
    *) sudo dnf --forcearch=x86_64 "$@";;
  esac
}
alias pkg="app"
alias copr="sudo dnf copr"
ver() { dnf info "$1" --installed | grep "Ver" | awk '{print $NF}'; }
activate() { source "$1/bin/activate"; }
alias open="handlr open"
alias handle="handlr"
alias c="code"
alias v="nvim"
@() {
case $1 in
  past) shift; jj obslog "$@";;
  *) jj "$@";; esac; }
_v() { nvim 2> /dev/null; }
fm() { exec &> /dev/null
  kitty sh -c "yazi"; }
t() { nvim -c ':terminal' 2> /dev/null; }
zle -N _v; zle -N t; zle -N fm
hl() { [ "$1" = "plug" ] && shift && hyprpm "$@" || hyprctl "$@"; }
alias h="hl"

alias fonts="fc-list : family"
alias s="fzf"
alias into="xargs -r"
alias f="rg $RG_COLORS -iP"
alias F="grep --color=auto --group-separator=$'\e[30m...\033[0m' -C3 -iP"
hl() { grep --color -E -- "$1|\$" "${@:2}"; }
alias re="perl -pe"
p() {
  if file --mime-type "$1" | grep -q "image/"; then kitten icat "$1"
  else bat --style=numbers,changes --color=always --tabs=2 "$1"; fi
}
alias pg="less -FSXKR"
alias pd="pwd"

lc() { awk 'END {print NR, "lines"}' "$@"; }
wc() { awk '{w += NF} END {print w, "words"}' "$@"; }
type() { file --mime-type "$1" | awk '{print $NF}'; }
alias info="eza --icons -AF -lOXm -T --level=0 --git --smart-group --time-style=relative"
alias space="grc lsblk -fne7 -o NAME,LABEL,SIZE,FSUSE%,MOUNTPOINTS"
much() { du -h -d 1 $1 2>/dev/null | grep --color=none '[0-9]\+G'; }
alias recover="foremost" # OR scalpel, photorec
alias i="info"; alias t="type"

csv() {
  grc column -t -s, "$@" | less -FSXK
}
alias table="csv"

snap() { # TBD
  case "$1" in
    list|ls) sudo snapper --csvout list --disable-used-space --all-configs -t all \
      --columns subvolume,number,pre-number,date,description | column -t -s, | grcat conf.snapper | less -FSXKR ;;
    *) sudo snapper "$@" ;;
  esac
}
alias snaps="snap list"

zshaddhistory() { # Validate commands* before appending to HISTFILE
  [[ $1 =~ "(https?)://[^ ]+" ]] && return 1
  whence ${${(z)1}[1]} > /dev/null || return 1
}

# —— SHORTCUTS ——————————————————

#     ..
alias ...="cd ../../"
alias ....="cd ../../../"

alias -g dl/="$DL/"
alias -g dots/="$DOTS/"
alias -g conf/="$CONFIG/"
alias -g dnf/="/etc/yum.repos.d/"
alias -g bin/="/bin/"
alias -g ubin/="/usr/bin/"
alias -g lbin/="$HOME/.local/bin/"
alias -g ushare/="/usr/share/"
alias -g lshare/="$HOME/.local/share/"
alias -g icons/="/usr/share/icons/"
alias -g desk/="/usr/share/applications/"
alias -g udev/="/etc/udev/rules.d/"
alias -g sys/="/etc/systemd/system/"
alias -g usys/="/etc/systemd/user/"
alias -g flat/="/var/lib/flatpak/app/"
alias -g uflat/="$HOME/.var/app/"
alias -g usb/="/run/media/$USER/"
alias -g trash/="$HOME/.local/share/Trash/files/"

alias -s {mp4,mkv,webm,avi,mov}="mpv &> /dev/null"
alias -s {mp3,m4a,flac,wav,ogg,opus}="play -q"
alias -s {png,jpg,jpeg,gif,webp}="swayimg"

# —— WIDGETS ————————————————————

files() {
  setopt LOCAL_OPTIONS NO_MONITOR
  local file="$(fd -0LI --type f --color=always | fzf -m --read0 --query="$BUFFER" \
    --bind='alt-v:reload(fd -0LHI --type=f --exclude=.git --max-depth=4 --color=always)' \
    --preview 'bat -n --color=always {}')"
  [ -n "$file" ] && xdg-open "$file" &> /dev/null & disown
  zle && zle reset-prompt
}
zle -N files

dirs() {
  local dir=$(fd -LI --type d . | fzf --query="$BUFFER" \
    --bind='alt-v:reload(fd -LHI --type=d --exclude='.git' --max-depth=4)' \
    --preview 'eza --icons -AF --color=always {}' --preview-window='30%') && cd "$dir"
  zle && zle reset-prompt
}
zle -N dirs

scan() {
  setopt LOCAL_OPTIONS NO_MONITOR; RGA="rga --files-with-matches -iP"
  local file="$(FZF_DEFAULT_COMMAND="$RGA '$1' | lscolors" fzf --sort --preview="[[ ! -z {} ]] && rga \
    --color=always --colors='match:bg:yellow' --colors='match:fg:black' --context-separator=$'\e[30m...\033[0m' -C1 {q} {}" \
    --phony -q "$1" --bind "change:reload:$RGA {q} | lscolors" --preview-window='50%')"
  [ -n "$file" ] && xdg-open "$file" &> /dev/null & disown
}

men() {
  man -k . | grcat conf.man | s --exact | awk '{print $1}' | xargs -r man
  zle && zle reset-prompt
}
zle -N men

hunt() {
  ps -u ${UID:-$(id -u)} -o pid,comm,cmd | grcat conf.ps \
  | fzf -m --query="$BUFFER" --header-lines=1 --bind 'space:toggle' | awk '{print $1}' | xargs -r kill -${1:-9}
  zle && zle reset-prompt
}
zle -N hunt

hist() {
  BUFFER=$(history 1 | grcat conf.ps | cut -f4- -d' ' | fzf +s --tac --exact --query="$BUFFER")
  zle && zle reset-prompt; CURSOR=${#BUFFER}
}
zle -N hist

where() {
  setopt LOCAL_OPTIONS NO_MONITOR
  local item=$(sudo locate / | fzf +s --exact)
  if [ -z "$BUFFER" ]; then
    [ -f "$item" ] && { xdg-open "$item" &> /dev/null & disown; }
    [ -d "$item" ] && cd "$item"
  else RBUFFER="$item"; fi # use as arg
  zle && zle reset-prompt; CURSOR=${#BUFFER}
}
zle -N where

gui() { 
  setopt LOCAL_OPTIONS NO_MONITOR
  local dir="${1:-.}"
  nautilus "$dir" &> /dev/null & disown
}
zle -N gui
