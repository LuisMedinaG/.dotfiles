# ───── History ─────
[ -z "$HISTFILE" ] && export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# History management
setopt appendhistory        # Append to history, don't overwrite
setopt incappendhistory     # Append to history immediately
setopt sharehistory         # Share command history across sessions
setopt hist_ignore_all_dups # Ignore all duplicate commands
setopt hist_save_no_dups    # Don't save duplicates
setopt hist_find_no_dups    # Don't find duplicates when searching
setopt histignorespace      # Ignore commands starting with space
setopt histverify           # Verify history expansions
setopt extendedhistory      # Save timestamp and duration
