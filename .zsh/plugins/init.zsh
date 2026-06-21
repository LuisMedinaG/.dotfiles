# Skip entirely in non-interactive shells (e.g. scripted/tool invocations) —
# zinit, fzf-tab, zoxide's cd widget, and syntax-highlighting all require zle,
# which isn't available there. Sourcing them anyway trips bindkey/zle errors.
[[ -o interactive ]] || return

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

### End of Zinit's installer chunk

# https://github.com/djui/alias-tips
# Turbo: defer one prompt cycle — no ordering constraint.
zinit ice wait lucid
zinit light djui/alias-tips

# https://github.com/wfxr/forgit
# export FORGIT_INSTALL_DIR="$HOMEBREW_PREFIX/share/forgit"
# source_if_exists $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh

# https://github.com/Aloxaf/fzf-tab
# Load synchronously: zstyles must be active before first completion invocation.
zinit light Aloxaf/fzf-tab

# Apply fzf-tab config unconditionally — zstyles are inert until fzf-tab loads.
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Previews — make tab completion visual
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  'if [ -d $realpath ]; then eza -1 --icons --color=always $realpath; elif [ -f $realpath ]; then bat -n --color=always --line-range :50 $realpath 2>/dev/null || cat $realpath; fi'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps -p $word -o pid,user,%cpu,%mem,command'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap'

# https://github.com/ajeetdsouza/zoxide
# For completions to work, the above line must be added after compinit is called.
# Cache `zoxide init` output (it's static) to avoid forking zoxide each shell.
if command -v zoxide >/dev/null 2>&1; then
  _zoxide_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zoxide_init.zsh"
  # Regen if missing/empty, or older than 7 days. (N.mh+168) = mtime > 168h ago.
  _zoxide_stale=( ${_zoxide_cache}(N.mh+168) )
  if [[ ! -s $_zoxide_cache || -n $_zoxide_stale ]]; then
    mkdir -p "${_zoxide_cache:h}"
    zoxide init zsh --cmd cd > "$_zoxide_cache"
  fi
  source "$_zoxide_cache"
  unset _zoxide_cache _zoxide_stale
fi

# https://github.com/olets/zsh-abbr — must come before syntax-highlighting.
# Use wait group '0a' so it loads before autosuggestions (0b) and syntax-hl (0c).
zinit ice wait'0a' lucid
zinit light olets/zsh-abbr

# https://github.com/zsh-users/zsh-autosuggestions
# Turbo: defer past first prompt; my-forward-move-word must stay in partial-accept list.
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(my-forward-move-word)
zinit ice wait'0b' lucid
zinit light zsh-users/zsh-autosuggestions

# https://github.com/zsh-users/zsh-syntax-highlighting — must be last.
# wait'0c' guarantees it loads after zsh-abbr (0a) and autosuggestions (0b).
zinit ice wait'0c' lucid
zinit light zsh-users/zsh-syntax-highlighting

# See: https://iterm2.com/documentation-shell-integration.html
# Only load inside an actual iTerm2 session — avoids file I/O in every other terminal.
[[ -n "$ITERM_SESSION_ID" ]] && source_if_exists "${HOME}/.iterm2_shell_integration.zsh"
