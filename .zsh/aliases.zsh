#
# ZSH Aliases
#

# File operations
alias l='eza --icons --group-directories-first -lha'
alias ls='eza --icons --group-directories-first -l'
alias cat='bat --paging=never --plain'
alias grep='rg'
# Note: 'grep' alias uses ripgrep syntax. Use \grep or command grep for POSIX grep.
alias vim='nvim'

# ZSH Abbr (https://zsh-abbr.olets.dev)
# Auto-expanding abbreviations, inspired by fish shell.
# Defined in: ~/.config/zsh-abbr/user-abbreviations
#
# Fallback aliases — used only if zsh-abbr is NOT loaded (e.g. brew package
# missing on a fresh machine). When zsh-abbr is active these are no-ops because
# the abbreviation expands the typed word before the alias is even consulted.
if ! (( $+functions[abbr] )); then
  alias ga='git add'
  alias gp='git push'
  alias gu='git pull'
  alias gc='git commit'
  alias gco='git checkout'
  alias gst='git status'
  alias gd='git diff'
  alias glo='git log --oneline --graph --decorate -20'
fi

# Directory stack shortcuts
# Generate aliases d1, d2, ... for dirs stack
alias d='dirs -v'
for index in {1..9}; do
    alias "d$index"="cd +$index"
done
unset index

# Include custom aliases
source_if_exists ~/.aliases.local
