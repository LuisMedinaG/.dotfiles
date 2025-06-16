#
# ZSH Aliases
#

# File operations
alias l='eza --icons --group-directories-first -lha'
alias ls='eza --icons --group-directories-first -l'
alias cat='bat'
alias grep='rg'
alias vim='nvim'

# ZSH Abbr (https://zsh-abbr.olets.dev)
# Auto-expanding abbreviations, inspired by fish shell.
# Alias commented (using abbr ~/.config/zsh-abbr/user-abbreviations)

# Pretty print the path
# alias path='echo $PATH | tr -s ":" "\n"'

# TODO: Use ZDOTDIR
# alias ez='code ~/.zshrc'
# alias sz='source ~/.zshrc'

# Git aliases
# alias g='git'
# alias gpl='git pull'
# alias gau='git add -u'
# alias gpo='git push origin'
# alias gch='git rev-parse HEAD | pbcopy'
# alias gsc='git branch --show-current | pbcopy'
# alias glu='git ls-files --modified --deleted --other --exclude-standard --deduplicate $(git rev-parse --show-toplevel)'
# alias gss="git status --short | grep '^[A-Z]' | awk '{print $NF}'"

# Navigation
# alias '...'='cd ../../'
# alias '....'='cd ../../../'
# alias '.....'='cd ../../../..'

# Directory stack shortcuts
# Generate aliases d1, d2, ... for dirs stack
alias d='dirs -v'
for index in {1..9}; do
    alias "d$index"="cd +$index"
done
unset index

# Include custom aliases
source_if_exists ~/.aliases.local
