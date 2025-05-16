#
# ZSH Aliases
#

# TODO: Use ZSH Abbreviations plugin instead of aliases
# File operations
alias ls='eza --icons --group-directories-first -l'
alias ll='eza --icons --group-directories-first -lha'
alias cat='bat'
alias grep='rg'
alias vim='nvim'

# TODO: Use ZDOTDIR
alias ez='code ~/.zshrc'
alias sz='source ~/.zshrc'

# Git aliases
alias g='git'
alias gpl='git pull'
alias gpo='git push origin'
alias ghc='git rev-parse HEAD | pbcopy'
alias gsc='git branch --show-current | pbcopy'
alias glu='git ls-files --modified --deleted --other --exclude-standard --deduplicate $(git rev-parse --show-toplevel)'
alias gls="git status --short | grep '^[A-Z]' | awk '{print $NF}'"

# Navigation
alias ...='cd ../../'
alias ....='cd ../../../'

# Directory stack shortcuts
# Generate aliases d1, d2, ... for dirs stack
alias d='dirs -v'
for index in {1..9}; do
    alias "d$index"="cd +$index"
done
unset index
