# —— ALIASES ————————————————————

alias reload="exec zsh"
alias load="zcomet load"

alias root="\sudo -sE"

mk() {
  [[ "${1: -1}" == "/" ]] && mkdir -p "${1:0:-1}" \
  || touch "$1"
}
alias rn="mv"
alias sys="systemctl"
alias net="nmcli"

# alias tar="tar -czvf"
# untar() { \tar -xvf "$1" --one-top-level="$2"; }
zip() { command zip -r "$1.zip" "$1"/; }
# unzip

alias py="python"

#     ..
alias ...="cd ../../"
alias ....="cd ../../../"

zshaddhistory() {
  [[ $(command wc -w <<< "$1") -le 1 ]] && return 1
  whence ${${(z)1}[1]} > /dev/null || return 1
}

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

fm() { 
  setopt LOCAL_OPTIONS NO_MONITOR
  local dir="${1:-.}"
  nautilus "$dir" &> /dev/null & disown
}
zle -N fm
