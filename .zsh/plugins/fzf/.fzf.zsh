# Setup fzf
# ---------

source <(fzf --zsh)

# Key bindings
source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"

zle     -N              fzf-cd-widget
bindkey -M emacs '\C-y' fzf-cd-widget
bindkey -M vicmd '\C-y' fzf-cd-widget
bindkey -M viins '\C-y' fzf-cd-widget

# Auto-completion
[[ $- == *i* ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" 2> /dev/null

_fzf_comprun() {
    local command=$1
    shift
    case "$command" in
        ls)                 fzf --preview 'tree -C {} | head -200'      "$@" ;;
        cd)                 find . -type d | fzf "$@" --preview 'tree -C {} | head -200' ;;
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
