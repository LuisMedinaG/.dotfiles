# Lazy loading NVM for faster shell startup
nvm() {
  unfunction nvm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  nvm "$@"
}

node() {
  unfunction node
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  node "$@"
}

npm() {
  unfunction npm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  npm "$@"
}

# Function to reload SSH keys with Yubikey
reload-ssh() {
  if command -v ssh-add >/dev/null; then
    if [ -f /usr/local/lib/opensc-pkcs11.so ]; then
      yubikey_lib="/usr/local/lib/opensc-pkcs11.so"
    elif [ -f /opt/homebrew/lib/opensc-pkcs11.so ]; then # Homebrew on Apple Silicon
      yubikey_lib="/opt/homebrew/lib/opensc-pkcs11.so"
    else
      echo "Error: OpenSC PKCS#11 library not found." >&2
      return 1
    fi

    cho "Attempting to remove previous card entries for $yubikey_lib..."
    ssh-add -e "$yubikey_lib" # Show output for debugging
    if [[ $? -gt 0 ]]; then echo "Failed to remove previous card"; fi

    echo "Attempting to add card: $yubikey_lib..."
    ssh-add -s "$yubikey_lib"
    ssh-add -l # List keys to confirm
  else
    echo "Error: ssh-add command not found." >&2
    return 1
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

# https://unix.stackexchange.com/a/282433
function addToPATH {
  case ":$PATH:" in
  *":$1:"*) : ;;        # already there
  *) PATH="$1:$PATH" ;; # or PATH="$PATH:$1"
  esac
}

# Function to cache command output
# Usage: cache_eval <cache_name> <command> <max_age_in_days>
cache_eval() {
  local cache_name="$1"
  local command="$2"
  local max_age="${3:-7}" # Default to 7 days max cache age

  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local cache_file="$cache_dir/$cache_name.zsh"

  # Create cache directory if it doesn't exist
  [[ ! -d "$cache_dir" ]] && mkdir -p "$cache_dir"

  # Check if cache exists and is recent enough
  if [[ ! -f "$cache_file" || $(find "$cache_file" -mtime +$max_age -print) ]]; then
    # Cache doesn't exist or is too old
    echo "# Generated on $(date)" >"$cache_file"
    eval "$command" >>"$cache_file" 2>/dev/null
  fi

  # Source the cache file
  source "$cache_file"
}

validateYaml() {
    python -c 'import yaml,sys;yaml.safe_load(sys.stdin)' < $1
}