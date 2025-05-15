#
# Luis Medina's ZSH Profile
# Managed with YADM
#

# ───── Core Configuration ─────
export LC_ALL="en_US.UTF-8"
export EDITOR="code"

# Environment Variables
[ -f ~/.zshenv ] && source ~/.zshenv

# History, Keybinding, Navigation and Shell behavior
[ -f ~/.zsh/options.zsh ] && source ~/.zsh/options.zsh

# Plugins, fzf, completion, syntax highlighting and shell integration
[ -f ~/.zsh/tools.zsh ] && source ~/.zsh/tools.zsh

[ -f ~/.zsh/aliases.zsh ] && source ~/.zsh/aliases.zsh

# ───── Prompt ─────
autoload -Uz colors && colors

PS1="%{$fg[cyan]%}%n@%m %{$fg[green]%}%1~ %{$reset_color%}%# "
RPROMPT="%{$fg[yellow]%}%*%{$reset_color%}"

# Oh My Posh:
# eval "$(oh-my-posh init zsh)"

# Starship:
# eval "$(starship init zsh)"
