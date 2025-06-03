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
# The zsh manager for auto-expanding abbreviations, inspired by fish shell.

# Pretty print the path
# abbr path='echo $PATH | tr -s ":" "\n"'

# TODO: Use ZDOTDIR
# abbr ez='code ~/.zshrc'
# abbr sz='source ~/.zshrc'

# Git aliases
# abbr g='git'
# abbr gpl='git pull'
# abbr gau='git add -u'
# abbr gpo='git push origin'
# abbr gch='git rev-parse HEAD | pbcopy'
# abbr gsc='git branch --show-current | pbcopy'
# abbr glu='git ls-files --modified --deleted --other --exclude-standard --deduplicate $(git rev-parse --show-toplevel)'
# abbr gss="git status --short | grep '^[A-Z]' | awk '{print $NF}'"

# Navigation
# abbr '...'='cd ../../'
# abbr '....'='cd ../../../'
# abbr '.....'='cd ../../../..'

# Directory stack shortcuts
# Generate aliases d1, d2, ... for dirs stack
alias d='dirs -v'
for index in {1..9}; do
    alias "d$index"="cd +$index"
done
unset index

# Include custom aliases
source_if_exists ~/.aliases.local
