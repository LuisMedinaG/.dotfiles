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

# Local overrides (machine-specific aliases, functions, etc.)
source_if_exists ~/.zshrc.local

# Print zsh profiling report when ZPROF=1. Activate with: ZPROF=1 zsh -i -c exit
# Use an `if` (not `&&`) so .zshrc's exit status stays 0 when ZPROF is unset —
# otherwise bare `zsh -i -c exit` returns 1 and breaks status checks.
if [[ "${ZPROF:-0}" == 1 ]]; then
  zprof | head -30
fi
