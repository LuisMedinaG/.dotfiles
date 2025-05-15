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
alias cdz='z'
alias y='yadm'

# Git shortcuts
alias g='git'
alias gpl='git pull'
alias gpo='git push origin'
alias gco='git checkout'
alias ghc='git rev-parse HEAD | pbcopy'
alias gsc='git branch --show-current | pbcopy'
alias glu='git ls-files --modified --deleted --other --exclude-standard --deduplicate $(git rev-parse --show-toplevel)'
alias gsf="git status --short | grep '^[A-Z]' | awk '{print $NF}'"
# alias gsa="git add $(git ls-files --modified --deleted --other --exclude-standard --deduplicate $(git rev-parse --show-toplevel) | fzf --multi --reverse --no-sort)"
# alias gua="git reset -- $(git status --short | grep '^[A-Z]' | awk '{print $NF}' | fzf --multi --reverse --no-sort)"

alias ez='vim ~/.zshrc'
alias sz='source ~/.zshrc && echo "ZSH config sourced."'

# Directory stack shortcuts
alias d='dirs -v'
for index ({1..9}); do alias "$index"="cd +$index"; done

# Function to reload SSH keys with Yubikey
reload-ssh() {
  if command -v ssh-add >/dev/null; then
    ssh-add -e /usr/local/lib/opensc-pkcs11.so > /dev/null
    if [[ $? -gt 0 ]]; then echo "Failed to remove previous card"; fi
    ssh-add -s /usr/local/lib/opensc-pkcs11.so
  fi
}

# Activate Python virtual environments
# https://seb.jambor.dev/posts/improving-shell-workflows-with-fzf/
function activate-venv() {
  local selected_env
  selected_env=$(ls ~/.venv/ | fzf)

  if [ -n "$selected_env" ]; then
    source "$HOME/.venv/$selected_env/bin/activate"
  fi
}
