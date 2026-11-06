# Lazy loading NVM for faster shell startup
# Only define wrappers if NVM is actually installed
if [ -s "${NVM_DIR:-$HOME/.nvm}/nvm.sh" ]; then
  # shell-safety.STARTUP.1
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

  # Helper to load NVM and remove lazy wrappers
  _nvm_load() {
    unfunction nvm node npm npx 2>/dev/null
    source "$NVM_DIR/nvm.sh" || return
    if [ -s "$NVM_DIR/bash_completion" ]; then
      source "$NVM_DIR/bash_completion"
    fi
  }

  # shell-safety.STARTUP.4
  function 'nvm'  { _nvm_load && \nvm "$@" }
  function 'node' { _nvm_load && \node "$@" }
  function 'npm'  { _nvm_load && \npm "$@" }
  function 'npx'  { _nvm_load && \npx "$@" }

  # Auto-switch Node version when entering a directory with .nvmrc
  autoload -U add-zsh-hook
  _nvm_auto_use() {
    if [ -f .nvmrc ]; then
      \nvm use 2>/dev/null
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

# Install fresh snapshots and restart the system daemon.
kanata-reload() {
  [[ "$(uname -s)" != Darwin ]] && { echo "kanata-reload: macOS only." >&2; return 1; }
  local label="io.lumedina.kanata"
  local plist="com.lumedina.kanata.plist"
  local daemon_path="/Library/LaunchDaemons/$plist"
  local runtime_dir="/Library/Kanata"
  local template="${ZSH:-$HOME/.zsh}/tools/$plist"
  local config="$HOME/.config/kanata/kanata.kbd"
  local binary
  binary=$(whence -p kanata) || { echo "kanata-reload: kanata is missing from PATH." >&2; return 1; }
  [[ -r "$config" ]] || { echo "kanata-reload: cannot read $config." >&2; return 1; }
  /usr/bin/plutil -lint "$template" || return

  # shell-safety.KANATA.1
  sudo /usr/bin/install -d -o root -g wheel -m 0755 "$runtime_dir" /Library/Logs/Kanata || return
  if sudo /bin/launchctl print "system/$label" >/dev/null 2>&1; then
    sudo /bin/launchctl bootout "system/$label" || return
  fi
  sudo /usr/bin/install -o root -g wheel -m 0755 "$binary" "$runtime_dir/kanata" || return
  sudo /usr/bin/install -o root -g wheel -m 0644 "$config" "$runtime_dir/kanata.kbd" || return
  sudo /usr/bin/install -o root -g wheel -m 0644 "$template" "$daemon_path" || return
  sudo /bin/launchctl bootstrap system "$daemon_path" || return
  echo "Kanata reloaded"
}

# Stop kanata daemon (macOS personal only)
kanata-stop() {
  [[ "$(uname -s)" != Darwin ]] && { echo "kanata-stop: macOS only." >&2; return 1; }
  # shell-safety.KANATA.2
  sudo /bin/launchctl bootout system/io.lumedina.kanata || return
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
  # shell-safety.UPDATES.1
  local failed=0
  if command -v brew >/dev/null 2>&1; then
    echo "── Homebrew ──"
    { brew update && brew upgrade && brew cleanup; } || failed=1
    echo ""
  fi

  echo "── Zinit plugins ──"
  zsh -ic "zinit update --all" || failed=1

  echo ""
  echo "── yadm pull ──"
  yadm pull || failed=1

  if command -v mackup >/dev/null 2>&1; then
    echo ""
    echo "── Mackup (app settings backup) ──"
    mackup backup --force || failed=1
  fi
  return "$failed"
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

  local source_dir destination_dir
  local -a source_git destination_git
  case "${1:-}" in
    to-clone)
      source_dir="$HOME" destination_dir="$clone_dir"
      source_git=(yadm) destination_git=(git -C "$clone_dir")
      ;;
    to-yadm)
      source_dir="$clone_dir" destination_dir="$HOME"
      source_git=(git -C "$clone_dir") destination_git=(yadm)
      ;;
    *)
      echo "Usage: dotfiles-sync <to-clone|to-yadm>"
      echo "  to-clone  Copy changed files from \$HOME to git clone"
      echo "  to-yadm   Copy changed files from git clone to \$HOME"
      return 1
      ;;
  esac

  # shell-safety.SYNC.2
  source_dir=${source_dir:A}
  destination_dir=${destination_dir:A}
  local changed file source_path target_path target_status
  local -a pending
  changed=$("${source_git[@]}" diff --name-only --no-relative --no-renames -z HEAD --) || return

  # shell-safety.SYNC.1
  for file in "${(@0)changed}"; do
    [[ -n "$file" ]] || continue
    source_path="$source_dir/$file"
    target_path="$destination_dir/$file"
    if [[ ! -f "$source_path" || "${source_path:A}" != "$source_path" ]]; then
      print -ru2 -- "dotfiles-sync: cannot copy deleted or non-regular source: $file"
      return 1
    fi
    if [[ -L "$target_path" || -d "$target_path" || "${target_path:A}" != "$target_path" ]]; then
      print -ru2 -- "dotfiles-sync: destination conflict: $file"
      return 1
    fi
    target_status=$(GIT_LITERAL_PATHSPECS=1 "${destination_git[@]}" status --porcelain --untracked-files=all --ignored=matching -- "$file") || return
    if [[ -n "$target_status" ]]; then
      print -ru2 -- "dotfiles-sync: destination conflict: $file"
      return 1
    fi
    pending+=("$file")
  done

  for file in "${pending[@]}"; do
    target_path="$destination_dir/$file"
    command mkdir -p "${target_path:h}" &&
      command cp "$source_dir/$file" "$target_path" || return
    print -r -- "  copied $file"
  done
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
