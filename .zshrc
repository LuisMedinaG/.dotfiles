#!/usr/bin/env zsh

#
# Luis Medina's ZSH Profile
# Managed with YADM
#

# for file in ~/.{path,prompt,exports,aliases,functions,extra}; do
# 	[ -r "$file" ] && [ -f "$file" ] && source "$file";
# done;
# unset file;

source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}

# Source the ZSH configuration
source_if_exists $HOME/.zshenv

source_if_exists $ZSH/exports.zsh
source_if_exists $ZSH/history.zsh
source_if_exists $ZSH/aliases.zsh
source_if_exists $ZSH/options.zsh
source_if_exists $ZSH/functions.zsh
source_if_exists $ZSH/prompt.zsh
source_if_exists $ZSH/completion.zsh

# Source the ZSH plugins
source_if_exists $ZSH/plugins/plugins.zsh

# precmd() {
#     source $DOTFILES/zsh/aliases.zsh
# }
