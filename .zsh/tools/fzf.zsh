# FZF Configuration
# -----------------

# -----------------------------------------------------------------------------
# Universal Base Settings (applied to ALL fzf instances)
# -----------------------------------------------------------------------------

# Color scheme - dark theme with selective highlighting
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

# Applied to: every fzf call unless explicitly overridden
export FZF_DEFAULT_OPTS="--height 70% \
--border sharp \
--color '$FZF_COLORS' \
--layout=reverse \
--info=inline \
--cycle \
--prompt '∷ ' \
--pointer=► \
--marker=✓"

# -----------------------------------------------------------------------------
# Search Engine (fd for performance)
# -----------------------------------------------------------------------------
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

# -----------------------------------------------------------------------------
# Key Bindings (Ctrl+T, Ctrl+R, Alt+C)
# -----------------------------------------------------------------------------

# Ctrl+T: file search
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target --preview 'bat -n --style=numbers --color=always {}'\ 
 --bind shift-up:preview-page-up,shift-down:preview-page-down\
 --bind 'ctrl-/:toggle-preview'"

# Ctrl+R: history search
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# Alt+G: directory navigation
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target --preview 'tree -C {}'"

# -----------------------------------------------------------------------------
# Tab Completion Enhancements
# -----------------------------------------------------------------------------

# Triggers _fzf_compgen_path:
# vim <TAB>          # Needs files
# cat <TAB>          # Needs files
# cp file1 <TAB>     # Second argument needs files
_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" "$1"
}

_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" "$1"
}

# Command-specific tab completion (ONLY for commands that benefit) 
# _fzf_comprun() {
#     local command=$1
#     shift
#     case "$command" in
#         cd) fzf --height=80% \
#         --walker-skip .git,node_modules,target \
#         --preview 'tree -C {}' \
#         --preview-window=right:35% \
#         "$@" ;;
#         *) fzf "$@" ;;
#     esac
# }

# Load key bindings and completion from Homebrew installation
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    # Key bindings
    source_if_exists "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"

    # Auto-completion
    [[ $- == *i* ]] && source_if_exists "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
fi


if [[ "$OSTYPE" == "darwin"* ]]; then
    # Reliable alternative to Alt+C on Mac
    bindkey "^G" fzf-cd-widget  # Ctrl+G for directory navigation
    
    # Try to make Alt+C work (requires terminal Option key configuration)
    bindkey "^[c" fzf-cd-widget
fi
