# —— VARS ———————————————————————

export CACHE="$HOME/.cache"
export CONFIG="$HOME/.config"
export LOCAL="$HOME/.local/share/"

export WORDCHARS=""
export ZSHZ_OWNER="bren"
export PROMPT_EOL_MARK=""
export EDITOR="code"

export PATH=$PATH:"$HOME/.local/bin"
export PATH=$PATH:"$HOME/.cargo/bin"

export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

export PATH=$PATH:"$HOME/.spicetify"

export MODULAR_HOME="$HOME/.modular"
export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"

export FZF_DEFAULT_OPTS="
--height=20 --info=inline-right --exit-0 --select-1 --color "hl+:-1:reverse"
--preview-window '70%' --layout=reverse --pointer=█ --marker=▍
--bind 'shift-delete:backward-kill-word'
--bind 'C:execute-silent(wl-copy "{+}" --trim-newline)'
--bind 'alt-p:change-preview-window(hidden|right)'
--bind 'space:toggle'"

export HSA_OVERRIDE_GFX_VERSION=10.3.0
