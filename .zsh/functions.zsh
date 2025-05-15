# ───── Functions ─────
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

# https://github.com/andrew8088/dotfiles/blob/main/zsh/aliases.zsh
function take {
    mkdir -p $1
    cd $1
}
