#
# ZSH Options
#

# Set up Zsh options. There are many of these that can be tweaked!
# See: https://zsh.sourceforge.io/Doc/Release/Options.html

# Directory navigation
setopt autocd # cd into dir without typing 'cd'
setopt pushdignoredups pushdminus autopushd pushd_silent

# History management
setopt appendhistory      # Append to history, don't overwrite
setopt inc_append_history # Append to history immediately
setopt sharehistory       # Share command history across sessions
setopt histignoredups     # Ignore duplicate commands in history
setopt incappendhistory   # Write to history immediately
setopt hist_ignore_all_dups hist_save_no_dups hist_find_no_dups histignorespace histverify extendedhistory
setopt hist_verify       # Do not execute immediately upon history expansion.
setopt hist_ignore_space # Do not record an event starting with a space.

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
bindkey -e
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# bindkey '[C' forward-word
# bindkey '[D' backward-word

# Custom word deletion
backward_delete_word() {
  local WORDCHARS='_-'
  zle backward-kill-word
}
zle -N backward_delete_word
bindkey '^W' backward_delete_word
