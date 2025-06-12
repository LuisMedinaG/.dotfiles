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
remove-delimiters() {
  # Copy the global WORDCHARS variable to a local variable. 
  local WORDCHARS=$WORDCHARS
  WORDCHARS="${WORDCHARS//:}"
  WORDCHARS="${WORDCHARS//\/}"
  WORDCHARS="${WORDCHARS//.}"
  echo "$WORDCHARS"
}

my-backward-move-word() {
  local WORDCHARS=$(remove-delimiters)
  zle backward-word
}

my-forward-move-word() {
  local WORDCHARS=$(remove-delimiters)
  zle forward-word
}

# New default `ctrl+w` command
my-backward-delete-word() {
  
  local WORDCHARS=$(remove-delimiters)
  # zle <widget-name> will run an existing widget.
  zle backward-kill-word
}

# This will be our `ctrl+alt+w` command
my-backward-delete-whole-word() {
  local WORDCHARS=$WORDCHARS
  # Add `:` to WORDCHARS if it's not present
  [[ ! $WORDCHARS == *":"* ]] && WORDCHARS="$WORDCHARS"":"
  zle backward-kill-word
}

# Register functions with ZLE
zle -N my-backward-move-word
zle -N my-forward-move-word
zle -N my-backward-delete-word
zle -N my-backward-delete-whole-word

# Key bindings
bindkey "^[b" my-backward-move-word     # VSCode Option+Left
bindkey "^[f" my-forward-move-word      # VSCode Option+Right
bindkey "^[[1;3D" my-backward-move-word # iTerm2 Option+Left
bindkey "^[[1;3C" my-forward-move-word  # iTerm2 Option+Right

bindkey '^W' my-backward-delete-word
# bindkey '^[^W' my-backward-delete-whole-word

bindkey '^E' end-of-line
bindkey '^A' beginning-of-line
