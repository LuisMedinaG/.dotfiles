#
# Luis Medina's ZSH Profile
# Managed with YADM
#

# ───── Core Configuration ─────
export LC_ALL="en_US.UTF-8"
export EDITOR="code"

[ -f ~/.zshenv ] && source ~/.zshenv

# History, Keybinding, Navigation and Shell behavior
[ -f ~/.zsh/options.zsh ] && source ~/.zsh/options.zsh

[ -f ~/.zsh/aliases.zsh ] && source ~/.zsh/aliases.zsh

# Plugins, fzf, completion, syntax highlighting and shell integration
[ -f ~/.zsh/tools.zsh ] && source ~/.zsh/tools.zsh

[ -f ~/.zsh/prompt.zsh ] && source ~/.zsh/prompt.zsh
