# Lazy loading NVM for faster shell startup
# Only define wrappers if NVM is actually installed
if [ -s "${NVM_DIR:-$HOME/.nvm}/nvm.sh" ]; then
  # Helper to load NVM and remove lazy wrappers
  _nvm_load() {
    unfunction nvm node npm npx 2>/dev/null
    source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  }

  nvm() { _nvm_load; nvm "$@" }
  node() { _nvm_load; node "$@" }
  npm() { _nvm_load; npm "$@" }
  npx() { _nvm_load; npx "$@" }

  # Auto-switch Node version when entering a directory with .nvmrc
  autoload -U add-zsh-hook
  _nvm_auto_use() {
    if [ -f .nvmrc ]; then
      # NVM_BIN is set by nvm.sh on load; absence means the lazy stub is still active
      [ -z "${NVM_BIN:-}" ] && _nvm_load
      nvm use 2>/dev/null
    fi
  }
  add-zsh-hook chpwd _nvm_auto_use
fi

# Activate Python virtual environments
# https://seb.jambor.dev/posts/improving-shell-workflows-with-fzf/
function activate-venv() {
  [[ -d ~/.venv ]] || { echo "No ~/.venv directory found." >&2; return 1; }
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

validateYaml() {
    python3 -c 'import yaml,sys;yaml.safe_load(sys.stdin)' < "$1"
}

# Build karabiner config from anywhere (macOS personal only)
karabiner-build() {
  [[ "$(uname -s)" != Darwin ]] && { echo "karabiner-build: macOS only." >&2; return 1; }
  npm --prefix "$HOME/.config/karabiner-config" run build
}

# Reload kanata config (restarts the LaunchDaemon) (macOS personal only)
# First run: creates log dir, copies plist, and loads the daemon
# Subsequent runs: just restarts the service
kanata-reload() {
  [[ "$(uname -s)" != Darwin ]] && { echo "kanata-reload: macOS only." >&2; return 1; }
  local plist="com.lumedina.kanata.plist"
  local daemon_path="/Library/LaunchDaemons/$plist"
  local log_dir="/Library/Logs/Kanata"

  # Create log directory if needed
  if [ ! -d "$log_dir" ]; then
    echo "Creating log directory $log_dir..."
    sudo mkdir -p "$log_dir"
  fi

  # Load daemon if not already registered
  if ! sudo launchctl list io.lumedina.kanata >/dev/null 2>&1; then
    echo "Loading kanata daemon..."
    sudo cp "$HOME/.config/kanata/$plist" "$daemon_path"
    sudo launchctl load "$daemon_path"
  else
    sudo launchctl stop io.lumedina.kanata
    sudo launchctl start io.lumedina.kanata
  fi
  echo "Kanata reloaded"
}

# Stop kanata daemon (macOS personal only)
kanata-stop() {
  [[ "$(uname -s)" != Darwin ]] && { echo "kanata-stop: macOS only." >&2; return 1; }
  sudo launchctl stop io.lumedina.kanata
  echo "Kanata stopped"
}

# Measure shell startup time
shell-time() {
  local iterations="${1:-10}"
  echo "Timing zsh startup ($iterations iterations)..."
  for i in $(seq 1 "$iterations"); do
    # Use zsh's built-in time for cleaner, parseable output
    TIMEFMT='  %E total (%U user, %S system)'
    { time zsh -i -c exit } 2>&1
  done
}

# Update everything: Homebrew (if present), Zinit plugins, yadm, and app settings
update-all() {
  if command -v brew >/dev/null 2>&1; then
    echo "── Homebrew ──"
    brew update && brew upgrade && brew cleanup
    echo ""
  fi

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
  # macOS: ~/Documents/Projects/.dotfiles  Linux: ~/projects/.dotfiles
  local clone_dir
  if [[ "$(uname -s)" == "Darwin" ]]; then
    clone_dir="$HOME/Documents/Projects/.dotfiles"
  else
    clone_dir="$HOME/projects/.dotfiles"
  fi
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

# Open file in nvim, splitting tmux window if inside a session.
# Without tmux, just opens nvim normally.
# Usage: nv file.txt  (horizontal split)  nvl file.txt  (vertical split)
_nvim_split() {
  local dir="${1:-}"; shift
  if [ -z "$TMUX" ] || [ $# -eq 0 ]; then
    command nvim "$@"
  else
    tmux split-window -"$dir" -c "#{pane_current_path}" nvim "$@"
  fi
}
nv()  { _nvim_split h "$@"; }
nvl() { _nvim_split v "$@"; }