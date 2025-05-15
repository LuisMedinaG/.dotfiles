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

# History options
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"

# Add files and directories color when running ls
# There's a generator here: http://geoff.greer.fm/lscolors/
export CLICOLOR=1
export LS_COLORS='di=36:ln=1;35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export GREP_COLOR='1;35;40'

# Oh My Posh:
# eval "$(oh-my-posh init zsh)"

# Starship:
# eval "$(starship init zsh)"
