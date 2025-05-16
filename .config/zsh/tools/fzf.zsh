# FZF Configuration
# -----------------

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
export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target --preview 'bat -n --style=numbers --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)' --bind shift-up:preview-page-up,shift-down:preview-page-down"
# cd into the selected directory
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target --preview 'tree -C {}'"

# Load key bindings and completion from Homebrew installation
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    # Key bindings
    source_if_exists "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"

    # Auto-completion
    [[ $- == *i* ]] && source_if_exists "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
fi

# Custom key binding for fzf-cd-widget
zle -N fzf-cd-widget
bindkey -M emacs '\C-y' fzf-cd-widget
bindkey -M vicmd '\C-y' fzf-cd-widget
bindkey -M viins '\C-y' fzf-cd-widget

# FZF completion function
_fzf_comprun() {
    local command=$1
    shift
    case "$command" in
    ls) fzf --preview 'tree -C {} | head -200' "$@" ;;
    cd) find . -type d | fzf "$@" --preview 'tree -C {} | head -200' ;;
    export | unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
    tree) find . -type d | fzf --preview 'tree -C {}' "$@" ;;
    *) fzf "$@" ;;
    esac
}

# Use fd for listing path candidates
_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" "$1"
}

_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" "$1"
}
