#!/usr/bin/env zsh

#
# Luis Medina's ZSH Configuration
# Managed with YADM
#

source_if_exists $ZSH/options.zsh    # Shell options
source_if_exists $ZSH/history.zsh    # History before completion
source_if_exists $ZSH/completion.zsh # Completion setup
source_if_exists $ZSH/functions.zsh  # Functions (incl. lazy loaders)
source_if_exists $ZSH/aliases.zsh    # Aliases
source_if_exists $ZSH/prompt.zsh     # Prompt setup

# Load tools/plugin configurations
source_if_exists $ZSH/tools/fzf.zsh    # FZF configuration
source_if_exists $ZSH/plugins/init.zsh # Plugin loader
