#
# ZSH Options
#

# Set up Zsh options. There are many of these that can be tweaked!
# See: https://zsh.sourceforge.io/Doc/Release/Options.html

# Directory navigation
setopt autocd # cd into dir without typing 'cd'
setopt pushdignoredups pushdminus autopushd pushd_silent

# Shell behavior
setopt correct # Auto-correct minor command misspellings
setopt interactivecomments
setopt nocaseglob # Case-insensitive globbing
setopt promptsubst
setopt alwaystoend
setopt autolist automenu completeinword

# Set up zsh up/down/home/end key search completions.
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Key bindings
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey '^E' end-of-line 
bindkey '^A' beginning-of-line 

# Custom word deletion
backward_delete_word() {
  local WORDCHARS='_-'
  zle backward-kill-word
}
zle -N backward_delete_word
bindkey '^W' backward_delete_word
