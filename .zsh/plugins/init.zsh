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

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# https://github.com/djui/alias-tips
source_if_exists $ZSH/plugins/alias-tips/alias-tips.plugin.zsh

# https://github.com/wfxr/forgit
# export FORGIT_INSTALL_DIR="$HOMEBREW_PREFIX/share/forgit"
# source_if_exists $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh

# https://github.com/Aloxaf/fzf-tab
source_if_exists $ZSH/plugins/fzf-tab/fzf-tab.plugin.zsh

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
