# Core environment variables ONLY - keep this file minimal

# ZSH directory structure
export ZSH=$HOME/.config/zsh
# export ZDOTDIR="$HOME"

# Editor
export EDITOR=code

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Source function for other files to use
source_if_exists() {
  [ -r "$1" ] && [ -f "$1" ] && source "$1";
}
