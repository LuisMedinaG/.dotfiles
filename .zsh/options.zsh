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

# Custom word functions
backward_move_word() {
  local WORDCHARS='_'
  zle backward-word
}

forward_move_word() {
  local WORDCHARS='_'
  zle forward-word
}

backward_delete_word() {
  local WORDCHARS='_'
  zle backward-kill-word
}

# Register functions with ZLE 
zle -N backward_delete_word
zle -N backward_move_word
zle -N forward_move_word

# Key bindings
bindkey "^[b" backward_move_word     # VSCode Option+Left
bindkey "^[f" forward_move_word      # VSCode Option+Right
bindkey "^[[1;3D" backward_move_word # iTerm2 Option+Left
bindkey "^[[1;3C" forward_move_word  # iTerm2 Option+Right

bindkey '^W' backward_delete_word

bindkey '^E' end-of-line
bindkey '^A' beginning-of-line
