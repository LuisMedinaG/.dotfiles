#
# ZSH Aliases
#

# Navigation
alias ...='cd ../../'
alias ....='cd ../../../'

# File operations
alias grep='grep --color=auto'
alias h='history 1'
alias l='ls -lAh'
alias cat='bat'
alias vim='nvim'

# Git shortcuts
alias g='git'
alias gpl='git pull'
alias gpo='git push origin'
alias gco='git checkout'
alias ghc='git rev-parse HEAD | pbcopy'
alias gsc='git branch --show-current | pbcopy'

# Directory stack shortcuts
alias d='dirs -v'
for index ({1..9}); do alias "$index"="cd +$index"; done
