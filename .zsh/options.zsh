#
# ZSH Options
#

# Directory navigation
setopt autocd             # cd into dir without typing 'cd'
setopt pushdignoredups pushdminus autopushd pushd_silent

# History management
setopt appendhistory      # Append to history, don't overwrite
setopt sharehistory       # Share command history across sessions
setopt histignoredups     # Ignore duplicate commands in history
setopt incappendhistory   # Write to history immediately
setopt hist_ignore_all_dups hist_save_no_dups hist_find_no_dups histignorespace histverify extendedhistory

# Shell behavior
setopt correct            # Auto-correct minor command misspellings
setopt interactivecomments
setopt nocaseglob         # Case-insensitive globbing
setopt promptsubst
setopt alwaystoend
setopt autolist automenu completeinword

# Key bindings
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey -e
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# Custom word deletion
backward_delete_word() {
  local WORDCHARS='_'
  zle backward-kill-word
}
zle -N backward_delete_word
bindkey '^W' backward_delete_word
