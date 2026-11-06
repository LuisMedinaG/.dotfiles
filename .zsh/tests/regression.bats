setup() {
  export HOME="$BATS_TEST_TMPDIR/home"
  export MODULES="$BATS_TEST_DIRNAME/.."
  case "$(uname -s)" in
    Darwin) clone="$HOME/Documents/Projects/.dotfiles" ;;
    *) clone="$HOME/projects/.dotfiles" ;;
  esac
  export clone
  mkdir -p "$clone"
}

init_sync_repos() {
  for repo in "$HOME" "$clone"; do
    git -C "$repo" init -q
    printf 'base\n' > "$repo/first"
    printf 'base\n' > "$repo/second"
    git -C "$repo" add first second
    git -C "$repo" -c user.name=Test -c user.email=test@example.test commit -qm base
  done
}

sync_dotfiles() {
  zsh -fc 'yadm() { git -C "$HOME" "$@"; }
    source "$MODULES/functions.zsh"
    dotfiles-sync "$1"' zsh "$1"
}

@test "shell-safety.SYNC.1 refuses a staged destination conflict before copying any file" {
  init_sync_repos
  printf 'incoming\n' > "$HOME/first"
  printf 'incoming\n' > "$HOME/second"
  printf 'destination\n' > "$clone/second"
  git -C "$clone" add second

  run sync_dotfiles to-clone

  [ "$status" -ne 0 ]
  [[ "$output" == *conflict*second* ]]
  [ "$(cat "$clone/first")" = base ]
  [ "$(cat "$clone/second")" = destination ]
}

@test "shell-safety.SYNC.1 refuses an untracked destination in the reverse direction" {
  init_sync_repos
  printf 'incoming\n' > "$clone/new file"
  git -C "$clone" add 'new file'
  printf 'destination\n' > "$HOME/new file"

  run sync_dotfiles to-yadm

  [ "$status" -ne 0 ]
  [ "$(cat "$HOME/new file")" = destination ]
}

@test "shell-safety.SYNC.2 copies a staged file with a newline in its name" {
  init_sync_repos
  file=$'new\nfile'
  printf 'incoming\n' > "$HOME/$file"
  git -C "$HOME" add "$file"

  run sync_dotfiles to-clone

  [ "$status" -eq 0 ]
  [ "$(cat "$clone/$file")" = incoming ]
}

@test "shell-safety.FZF.1 completes files and directories under an absolute root" {
  command -v fd >/dev/null || skip 'fd is required'
  mkdir -p "$HOME/search root/nested"
  touch "$HOME/search root/nested/example"

  run zsh -fc 'source_if_exists() { :; }
    source "$MODULES/tools/fzf.zsh"
    _fzf_compgen_path "$1" && _fzf_compgen_dir "$1"' zsh "$HOME/search root"

  [ "$status" -eq 0 ]
  [[ "$output" == *"$HOME/search root/nested/example"* ]]
  [ "$(printf '%s\n' "$output" | grep -Fxc "$HOME/search root/nested/")" -eq 2 ]
}

@test "shell-safety.COMPLETION.1 rebuilds an old dump with an unchanged header" {
  export ZDOTDIR="$HOME"
  run zsh -fc 'setopt extendedglob; source "$MODULES/completion.zsh"'
  [ "$status" -eq 0 ]
  printf '\nprint stale-dump-was-sourced\n' >> "$HOME/.zcompdump"
  touch -t 200001010000 "$HOME/.zcompdump"

  run zsh -fc 'setopt extendedglob; source "$MODULES/completion.zsh"'

  [ "$status" -eq 0 ]
  [[ "$output" != *stale-dump-was-sourced* ]]
  ! grep -q stale-dump-was-sourced "$HOME/.zcompdump"
}

@test "shell-safety.COMPLETION.1 excludes a directory that becomes insecure after caching" {
  export ZDOTDIR="$HOME"
  mkdir -p "$HOME/completions"
  printf '#compdef audit-fixture\n' > "$HOME/completions/_audit_fixture"

  run zsh -fc 'setopt extendedglob; fpath=("$HOME/completions" $fpath)
    source "$MODULES/completion.zsh"; [[ ${_comps[audit-fixture]} = _audit_fixture ]]'
  [ "$status" -eq 0 ]
  chmod o+w "$HOME/completions"

  run zsh -fc 'setopt extendedglob; fpath=("$HOME/completions" $fpath)
    source "$MODULES/completion.zsh"; [[ -z ${_comps[audit-fixture]} ]]'
  [ "$status" -eq 0 ]
}

@test "shell-safety.COMPLETION.2 lists literal SSH aliases and strips known host ports" {
  export ZDOTDIR="$HOME"
  mkdir -p "$HOME/.ssh"
  printf '  Host first second *.example !ignored # comment\nHost=third\n' > "$HOME/.ssh/config"
  printf '%s\n' '[porthost]:2222,alias key' '|1|hash|salt key' '@cert-authority *.example key' '[broken key' > "$HOME/.ssh/known_hosts"

  run zsh -fc 'setopt extendedglob; source "$MODULES/completion.zsh"; _ssh_completion_hosts'

  [ "$status" -eq 0 ]
  for host in first second third porthost alias; do
    printf '%s\n' "$output" | grep -Fxq "$host"
  done
  [[ "$output" != *'*.example'* && "$output" != *'@cert-authority'* ]]
  [[ "$output" != *'|1|hash|salt'* && "$output" != *'[broken'* ]]
}

@test "shell-safety.STARTUP.1 loads NVM from the default directory" {
  mkdir -p "$HOME/.nvm"
  printf 'nvm() { print -r -- "loaded $*"; }\n' > "$HOME/.nvm/nvm.sh"

  run zsh -fc 'unset NVM_DIR; source "$MODULES/functions.zsh"; nvm version'

  [ "$status" -eq 0 ]
  [ "$output" = 'loaded version' ]
}

@test "shell-safety.STARTUP.4 reloads functions with an npm alias already defined" {
  export NVM_DIR="$HOME/.nvm"
  mkdir -p "$NVM_DIR" "$HOME/bin"
  printf 'export PATH="$HOME/bin:$PATH"\n' > "$NVM_DIR/nvm.sh"
  printf '#!/bin/sh\necho "npm binary $*"\n' > "$HOME/bin/npm"
  chmod +x "$HOME/bin/npm"

  run zsh -fic 'alias npm="print npm-alias"
    source "$MODULES/functions.zsh" || exit
    (( $+functions[kanata-reload] )) || exit 1
    \npm version && alias npm'

  [ "$status" -eq 0 ]
  [[ "$output" == *'npm binary version'*"npm='print npm-alias'"* ]]
}

@test "shell-safety.STARTUP.2 retains the last good cache when generation fails" {
  export XDG_CACHE_HOME="$HOME/cache with spaces"
  mkdir -p "$XDG_CACHE_HOME/zsh" "$HOME/.local/share/zinit/zinit.git"
  printf 'zinit() { return 1; }\n' > "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
  cache="$XDG_CACHE_HOME/zsh/zoxide_init.zsh"
  printf 'print old-cache\n' > "$cache"
  touch -t 200001010000 "$cache"

  run zsh -fic 'zoxide() { print partial-cache; return 1; }
    source "$MODULES/plugins/init.zsh"; :'

  [ "$status" -eq 0 ]
  [[ "$output" == *old-cache* && "$output" != *partial-cache* ]]
  [ "$(cat "$cache")" = 'print old-cache' ]
}

@test "shell-safety.STARTUP.3 returns the clone failure without sourcing Zinit" {
  mkdir -p "$HOME/bin"
  printf '#!/bin/sh\necho clone-failed >&2\nexit 23\n' > "$HOME/bin/git"
  chmod +x "$HOME/bin/git"
  export PATH="$HOME/bin:$PATH"

  run zsh -fic 'source "$MODULES/plugins/init.zsh"'

  [ "$status" -eq 23 ]
  [[ "$output" == *clone-failed* && "$output" != *'no such file'* ]]
}

@test "shell-safety.UPDATES.1 reports Zinit failure even when later steps succeed" {
  run zsh -fc 'source "$MODULES/functions.zsh"
    brew() { return 0; }
    zsh() { print -u2 zinit-failed; return 1; }
    yadm() { print yadm-ran; }
    mackup() { print backup-ran; }
    update-all'

  [ "$status" -eq 1 ]
  [[ "$output" == *zinit-failed*yadm-ran*backup-ran* ]]
}

@test "shell-safety.KANATA.2 returns a failed unload without reporting success" {
  run zsh -fc 'source "$MODULES/functions.zsh"
    uname() { print Darwin; }
    sudo() { print -r -- "$*"; return 23; }
    kanata-stop'

  [ "$status" -eq 23 ]
  [ "$output" = '/bin/launchctl bootout system/io.lumedina.kanata.manual' ]
}

@test "shell-safety.KANATA.3 bootstraps a manual job outside launchd startup directories" {
  [ "$(uname -s)" = Darwin ] || skip 'launchd is macOS only'
  mkdir -p "$HOME/bin" "$HOME/.config/kanata"
  touch "$HOME/.config/kanata/kanata.kbd"
  printf '#!/bin/sh\nexit 0\n' > "$HOME/bin/kanata"
  chmod +x "$HOME/bin/kanata"
  export PATH="$HOME/bin:$PATH"

  run zsh -fc 'export ZSH="$MODULES"; source "$MODULES/functions.zsh"
    sudo() { print -r -- "$*"; }
    kanata-reload'

  [ "$status" -eq 0 ]
  [[ "$output" == *'bootout system/io.lumedina.kanata.manual'* ]]
  [[ "$output" == *'bootstrap system /Library/Kanata/com.lumedina.kanata.plist'* ]]
  [[ "$output" != *'/Library/LaunchDaemons/'* && "$output" != *'launchctl enable'* ]]
  [ "$(/usr/bin/plutil -extract Label raw -o - "$MODULES/tools/com.lumedina.kanata.plist")" = io.lumedina.kanata.manual ]
}
