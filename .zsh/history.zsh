# ───── History ─────
[ -z "$HISTFILE" ] && export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# History management
setopt appendhistory      # Append to history, don't overwrite
setopt inc_append_history # Append to history immediately
setopt sharehistory       # Share command history across sessions
setopt histignoredups     # Ignore duplicate commands in history
setopt incappendhistory   # Write to history immediately
setopt hist_ignore_all_dups hist_save_no_dups hist_find_no_dups histignorespace histverify extendedhistory
setopt hist_verify       # Do not execute immediately upon history expansion.
setopt hist_ignore_space # Do not record an event starting with a space.
