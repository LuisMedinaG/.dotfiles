#
# ZSH Options
#

# Set up Zsh options. There are many of these that can be tweaked!
# See: https://zsh.sourceforge.io/Doc/Release/Options.html

# Directory navigation
setopt autocd # cd into dir without typing 'cd'
setopt pushdignoredups pushdminus autopushd pushd_silent

# Shell behavior
setopt NO_BEEP # Disable terminal bell
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

# Custom word functions — treat : / . as word boundaries
# Inlined to avoid subshell overhead on every keypress
my-backward-move-word() {
  local WORDCHARS="${WORDCHARS//:}"
  WORDCHARS="${WORDCHARS//\/}"
  WORDCHARS="${WORDCHARS//.}"
  zle backward-word
}

my-forward-move-word() {
  local WORDCHARS="${WORDCHARS//:}"
  WORDCHARS="${WORDCHARS//\/}"
  WORDCHARS="${WORDCHARS//.}"
  zle forward-word
}

# Delete word with `ctrl+w`
my-backward-delete-word() {
  local WORDCHARS="${WORDCHARS//:}"
  WORDCHARS="${WORDCHARS//\/}"
  WORDCHARS="${WORDCHARS//.}"
  zle backward-kill-word
}

# Delete whole word with `ctrl+alt+w`
my-backward-delete-whole-word() {
  local WORDCHARS=$WORDCHARS
  # Add `:` to WORDCHARS if it's not present
  [[ ! $WORDCHARS == *":"* ]] && WORDCHARS="$WORDCHARS"":"
  # zle <widget-name> will run an existing widget.
  zle backward-kill-word
}

# Register functions with ZLE
zle -N my-backward-move-word
zle -N my-forward-move-word
zle -N my-backward-delete-word
zle -N my-backward-delete-whole-word

# Word-movement key bindings — covers Terminal.app, iTerm2, VS Code, Ghostty,
# Warp, and tmux passthrough. Different terminals send different escape
# sequences for Option+Left/Right; bind them all so it Just Works.
#
# REQUIREMENT for Terminal.app: enable
#   Settings → Profiles → Keyboard → "Use Option as Meta key"
# Without that, the keys never reach zsh and no binding can help.
bindkey "^[b"      my-backward-move-word  # Meta+b (Option-as-Meta)
bindkey "^[f"      my-forward-move-word   # Meta+f
bindkey "^[[1;3D"  my-backward-move-word  # CSI 1;3D — iTerm2/Terminal.app
bindkey "^[[1;3C"  my-forward-move-word   # CSI 1;3C
bindkey "^[[1;9D"  my-backward-move-word  # CSI 1;9D — alt mac mapping
bindkey "^[[1;9C"  my-forward-move-word
bindkey "^[^[[D"   my-backward-move-word  # ESC ESC [D — older Terminal.app
bindkey "^[^[[C"   my-forward-move-word
bindkey "^[OD"     my-backward-move-word  # Application cursor mode
bindkey "^[OC"     my-forward-move-word
bindkey "^[D"      my-backward-move-word  # ESC+D — Terminal.app default profile
bindkey "^[C"      my-forward-move-word   # ESC+C

bindkey '^W' my-backward-delete-word
# bindkey '^[^W' my-backward-delete-whole-word

# History search: type partial command, then Up/Down to search history
bindkey '^[[A' history-beginning-search-backward-end  # Up arrow
bindkey '^[[B' history-beginning-search-forward-end   # Forward arrow

bindkey '^E' end-of-line
bindkey '^A' beginning-of-line
# Home/End keys (broader terminal support)
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
