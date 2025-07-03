#!/usr/bin/env zsh

# Luis Medina's ZSH Configuration
# Managed with YADM

# $ZSH and source_if_exists should be available from .zshenv
source_if_exists $ZSH/options.zsh
source_if_exists $ZSH/history.zsh
source_if_exists $ZSH/completion.zsh
source_if_exists $ZSH/functions.zsh
source_if_exists $ZSH/aliases.zsh
source_if_exists $ZSH/prompt.zsh

# Load tools/plugin configurations
source_if_exists $ZSH/tools/fzf.zsh
source_if_exists $ZSH/plugins/init.zsh