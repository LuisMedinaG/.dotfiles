# +---------+
# | General |
# +---------+

# Load completions
[ -n "$BREW_COMPLETIONS_PATH" ] && fpath=($BREW_COMPLETIONS_PATH/src $fpath)
zmodload zsh/complist

# Use hjlk in menu selection (during completion)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

bindkey -M menuselect '^xu' undo # Undo

autoload -U compinit
compinit
_comp_options+=(globdots) # With hidden files

# +---------+
# | Options |
# +---------+

setopt GLOB_COMPLETE    # Show autocompletion menu with globs
setopt MENU_COMPLETE    # Automatically highlight first element of completion menu
setopt AUTO_LIST        # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD # Complete from both ends of a word.

# +---------+
# | zstyles |
# +---------+

# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.config/zsh/.zcompcache" # "${ZDOTDIR:-$HOME/.config/zsh}/.zcompcache"
# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true

zle -C alias-expansion complete-word _generic
bindkey '^Xa' alias-expansion
zstyle ':completion:alias-expansion:*' completer _expand_alias

# Use cache for commands which use it

# Allow you to select in a menu
zstyle ':completion:*' menu select

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

zstyle ':completion:*' file-sort modification

# Formatting
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Colors for files and directory
# zstyle ':completion:*:*:*:*:default' list-colors "${(s.:.)LS_COLORS}"

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases

# Case-insensitive matching (important feature)
# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' keep-prefix true

# SSH hosts completion
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
# zstyle -e ":completion:*:(ssh|scp|sftp|rsh|rsync):hosts" hosts \
#     'reply=(${=${${(f)"$(
#       { \
#         command cat ~/.ssh/known_hosts ~/.ssh/config /etc/hosts /etc/ssh/ssh_known_hosts 2>/dev/null | \
#         command grep -i "^\s*Host\s" | command awk '{print $2}' | command grep -v "[*?]" ; \
#         command cat ~/.ssh/known_hosts 2>/dev/null | command awk '{print $1}' | command cut -d, -f1 | command grep -v "[*?\[]" ; \
#       } | command sort -u
#     )"}%%[# ]*}//,/ })'
