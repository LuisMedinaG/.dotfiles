# https://github.com/djui/alias-tips
source_if_exists $ZSH/plugins/alias-tips/alias-tips.plugin.zsh

# https://github.com/wfxr/forgit
source_if_exists $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh
PATH="$PATH:$FORGIT_INSTALL_DIR/bin"

# https://github.com/Aloxaf/fzf-tab
source_if_exists $ZSH/plugins/fzf-tab/fzf-tab.plugin.zsh
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# https://github.com/ajeetdsouza/zoxide
# For completions to work, the above line must be added after compinit is called.
eval "$(zoxide init zsh --cmd cd)"

# https://github.com/zsh-users/zsh-autosuggestions
source_if_exists $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# See: https://github.com/zsh-users/zsh-syntax-highlighting
source_if_exists $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# See: https://iterm2.com/documentation-shell-integration.html
source_if_exists "${HOME}/.iterm2_shell_integration.zsh"

# ───── Broot ───── 
# source $HOME/.config/broot/launcher/bash/br
