#!/usr/bin/env zsh

#
# Luis Medina's ZSH Configuration
# Managed with YADM
#

for file in "$ZSH/"{options,history,completion,functions,aliases,prompt}.zsh; do
  source_if_exists "$file"
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Source modular configuration files in logical order
source_if_exists $ZSH/options.zsh    # Then shell options
source_if_exists $ZSH/history.zsh    # History before completion (uses options)
source_if_exists $ZSH/completion.zsh # Completion setup
source_if_exists $ZSH/functions.zsh  # Functions (incl. lazy loaders)
source_if_exists $ZSH/aliases.zsh    # Aliases (might use functions)
source_if_exists $ZSH/prompt.zsh     # Prompt setup (last core config)

# Load tools/plugin configurations
source_if_exists $ZSH/tools/fzf.zsh       # FZF configuration
source_if_exists $ZSH/plugins/init.zsh # Plugin loader
