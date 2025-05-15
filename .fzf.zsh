#!/usr/bin/env zsh

zle     -N            fzf-cd-widget
bindkey -M emacs '\C-e' fzf-cd-widget
bindkey -M vicmd '\C-e' fzf-cd-widget
bindkey -M viins '\C-e' fzf-cd-widget

FZF_COLORS="bg+:-1,\
fg:gray,\
fg+:white,\
border:black,\
spinner:0,\
hl:yellow,\
header:blue,\
info:green,\
pointer:red,\
marker:blue,\
prompt:gray,\
hl+:red"

export FZF_DEFAULT_OPTS="--height 60% \
--border sharp \
--color '$FZF_COLORS' \
--layout=reverse \
--info=inline --cycle \
--prompt '∷ ' \
--pointer=► \
--marker=✓"

export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree"

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Search command history
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
# Preview files
export FZF_CTRL_T_OPTS="--preview 'bat -n --style=numbers --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)' --bind shift-up:preview-page-up,shift-down:preview-page-down"
# cd into the selected directory
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target --preview 'tree -C {}'"

if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
    PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

source <(fzf --zsh)

_fzf_comprun() {
    local command=$1
    shift
    case "$command" in
        ls)                 fzf --preview 'tree -C {} | head -200'      "$@" ;;
        cd)                 rg -d . | fzf "$@" --preview 'tree -C {} | head -200' ;;
        export | unset)     fzf --preview "eval 'echo \$'{}"            "$@" ;;
        tree)               find . -type d | fzf --preview 'tree -C {}' "$@";;
        *)                  fzf "$@" ;;
    esac
}

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" "$1"
}

_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" "$1"
}

# https://thevaluable.dev/fzf-shell-integration/
# _fzf_complete_git() {
#   _fzf_complete -- "$@" < <(
#     git --help -a | grep -E '^\s+' | awk '{print $1}'
#   )
# }
