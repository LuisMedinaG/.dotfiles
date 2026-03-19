# Lazy loading NVM for faster shell startup
# Only define wrappers if NVM is actually installed
if [ -s "${NVM_DIR:-$HOME/.nvm}/nvm.sh" ]; then
  nvm() {
    unfunction nvm node npm
    source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
    nvm "$@"
  }

  node() {
    unfunction nvm node npm
    source "$NVM_DIR/nvm.sh"
    node "$@"
  }

  npm() {
    unfunction nvm node npm
    source "$NVM_DIR/nvm.sh"
    npm "$@"
  }

  # Auto-switch Node version when entering a directory with .nvmrc
  autoload -U add-zsh-hook
  _nvm_auto_use() {
    if [ -f .nvmrc ]; then
      # Ensure NVM is loaded
      if ! command -v nvm | grep -q function 2>/dev/null; then
        unfunction nvm node npm 2>/dev/null
        source "$NVM_DIR/nvm.sh"
      fi
      nvm use 2>/dev/null
    fi
  }
  add-zsh-hook chpwd _nvm_auto_use
fi

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

    echo "Attempting to remove previous card entries for $yubikey_lib..."
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
  mkdir -p "$1" && cd "$1"
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
    python3 -c 'import yaml,sys;yaml.safe_load(sys.stdin)' < "$1"
}

# Build karabiner config from anywhere
karabiner-build() {
  npm --prefix "$HOME/.config/karabiner-config" run build
}

# Measure shell startup time
shell-time() {
  local iterations="${1:-10}"
  echo "Timing zsh startup ($iterations iterations)..."
  for i in $(seq 1 "$iterations"); do
    /usr/bin/time zsh -i -c exit 2>&1
  done
}

# Update everything: Homebrew, Zinit plugins, yadm, and app settings
update-all() {
  echo "── Homebrew ──"
  brew update && brew upgrade && brew cleanup

  echo ""
  echo "── Zinit plugins ──"
  zsh -ic "zinit update --all" 2>/dev/null

  echo ""
  echo "── yadm pull ──"
  yadm pull

  if command -v mackup >/dev/null 2>&1; then
    echo ""
    echo "── Mackup (app settings backup) ──"
    mackup backup --force
  fi
}

# Sync dotfiles between yadm worktree ($HOME) and git clone
dotfiles-sync() {
  local clone_dir="$HOME/Documents/Projects/.dotfiles"
  if [ ! -d "$clone_dir/.git" ]; then
    echo "Error: Git clone not found at $clone_dir" >&2
    return 1
  fi

  local direction="${1:-}"
  case "$direction" in
    to-clone)
      echo "Syncing yadm → git clone..."
      yadm diff --name-only | while read -r file; do
        cp "$HOME/$file" "$clone_dir/$file" 2>/dev/null && echo "  copied $file"
      done
      ;;
    to-yadm)
      echo "Syncing git clone → yadm..."
      git -C "$clone_dir" diff --name-only | while read -r file; do
        cp "$clone_dir/$file" "$HOME/$file" 2>/dev/null && echo "  copied $file"
      done
      ;;
    *)
      echo "Usage: dotfiles-sync <to-clone|to-yadm>"
      echo "  to-clone  Copy changed files from \$HOME to git clone"
      echo "  to-yadm   Copy changed files from git clone to \$HOME"
      ;;
  esac
}