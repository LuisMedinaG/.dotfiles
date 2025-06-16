# +---------+
# | General |
# +---------+

# Load completions
[ -n "$BREW_COMPLETIONS_PATH" ] && fpath=($BREW_COMPLETIONS_PATH/src $fpath)
zmodload zsh/complist

# https://github.com/olets/zsh-abbr
# The zsh manager for auto-expanding abbreviations, inspired by fish shell.
source_if_exists $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh

if type brew &>/dev/null; then
  FPATH=$HOMEBREW_PREFIX/share/zsh-abbr:$FPATH
fi

# ───── Optimized Completion System Init ─────
autoload -U compinit

# Define zcompdump file location
zcompdump_file="${ZDOTDIR:-$HOME}/.zcompdump"

# Only regenerate completion cache once per day
if [[ ! -f "$zcompdump_file" || -n "$(find "$zcompdump_file" -mtime +1 2>/dev/null)" ]]; then
  # Regenerate completion cache
  compinit -i -d "$zcompdump_file"
else
  # Use existing cache
  compinit -C -i -d "$zcompdump_file"
fi
_comp_options+=(globdots) # With hidden files

# +---------+
# | Options |
# +---------+

setopt GLOB_COMPLETE    # Show autocompletion menu with globs
setopt MENU_COMPLETE    # Automatically highlight first element of completion menu
setopt AUTO_LIST        # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD # Complete from both ends of a word.

# Use hjlk in menu selection (during completion)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^xu' undo # Undo

# +---------+
# | zstyles |
# +---------+

# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"
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
# zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases

# Case-insensitive matching (important feature)
# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' keep-prefix true

# ------------------------------------
# fzf-tab plugin common configuration 
# ------------------------------------

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# set list-colors to enable filename colorizing
zstyle ":completion:*" list-colors "${(s.:.)ZLS_COLORS}"
# set descriptions format to enable options to be grouped into "completion groups"
zstyle ":completion:*:descriptions" format "[%d]"

# switch between "completion groups" using `<` and `>` keys
zstyle ':fzf-tab:*' switch-group '<' '>'

# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default. To do so, set `use-fzf-default-opts` to `yes`
# This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# FZF_TAB_DEFAULT_FZF_FLAGS=(
#   "--height=~85%"
#   "--walker-skip .git,node_modules,target"
#   "--preview 'tree -C {}'"
#   "--preview-window=right:35%"
# )
# zstyle ":fzf-tab:*" fzf-flags "${FZF_TAB_DEFAULT_FZF_FLAGS[@]}"

# preview directory's content with eza when completing cd
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# SSH hosts completion
# zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts '
  reply=(
    ${=${${(f)"$(
      {
        # Get hosts from SSH config files
        command cat ~/.ssh/config ~/.ssh/config-oneview ~/.ssh/config-hivemind /etc/ssh/ssh_config 2>/dev/null |
        command grep -i "^\\s*Host\\s" | command awk "{print \$2}" | 
        command grep -v "\\*" ;
        
        # Get hosts from known_hosts files
        command cat ~/.ssh/known_hosts /etc/ssh/ssh_known_hosts 2>/dev/null |
        command awk "{print \$1}" | command cut -d, -f1 | 
        command grep -v "\\[|\\*" | command sed "s/].*//g" ;
        
        # Get hosts from /etc/hosts
        command cat /etc/hosts 2>/dev/null |
        command grep -v "^#" | command grep -v "^\\s*$" |
        command awk "{print \$2}" ;
      } | command sort -u
    )"}%%[# ]*}//,/ }
  )
'
