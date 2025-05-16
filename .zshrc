#!/usr/bin/env zsh

# Luis Medina's ZSH Configuration
# Managed with YADM

# $ZSH and source_if_exists should be available from .zshenv
source_if_exists $ZSH/options.zsh
source_if_exists $ZSH/history.zsh
source_if_exists $ZSH/functions.zsh
source_if_exists $ZSH/aliases.zsh

# Source completion settings (which sets up fpath for brew zsh-completions)
source_if_exists $ZSH/completion.zsh

# # Optimized compinit loading:
# autoload -Uz compinit
# local zcompdump_file=$HOME/.zsh/.zcompdump # Use ZDOTDIR
# # Recreate the dump file if it doesn't exist OR if it exists and is older than 24 hours.
# # Otherwise, load the existing (presumably fresh) dump file.
# if [[ ! -f "$zcompdump_file" ]] || [[ $(find "$zcompdump_file" -mtime +0 2>/dev/null) ]]; then
#     compinit -C -i -d "$zcompdump_file"
# else
#     compinit -i -d "$zcompdump_file" # Load existing dump file
# fi

# Load tools/plugin configurations
source_if_exists $ZSH/tools/fzf.zsh
source_if_exists $ZSH/plugins/init.zsh

source_if_exists $ZSH/prompt.zsh
