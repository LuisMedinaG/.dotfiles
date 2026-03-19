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
zinit light djui/alias-tips

# https://github.com/wfxr/forgit
# export FORGIT_INSTALL_DIR="$HOMEBREW_PREFIX/share/forgit"
# source_if_exists $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh

# https://github.com/Aloxaf/fzf-tab
zinit light Aloxaf/fzf-tab

# Apply fzf-tab config if it loaded successfully
if (( $+functions[fzf-tab-complete] )); then
    zstyle ':completion:*' menu no
    zstyle ':fzf-tab:*' switch-group '<' '>'
    zstyle ':fzf-tab:*' use-fzf-default-opts yes
fi

# https://github.com/ajeetdsouza/zoxide
# For completions to work, the above line must be added after compinit is called.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# https://github.com/zsh-users/zsh-autosuggestions
source_if_exists $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# See: https://github.com/zsh-users/zsh-syntax-highlighting
source_if_exists $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# See: https://iterm2.com/documentation-shell-integration.html
source_if_exists "${HOME}/.iterm2_shell_integration.zsh"
