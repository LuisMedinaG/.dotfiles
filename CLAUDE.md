# Dotfiles — CLAUDE.md

This is a macOS dotfiles repository managed by [yadm](https://yadm.io/) (Yet Another Dotfiles Manager).

## Quick Reference

- **Run tests:** `sh tests/run_all.sh`
- **Brewfile:** `.config/brew/Brewfile`
- **Bootstrap entry point:** `.config/yadm/bootstrap`
- **Bootstrap phases:** `.config/yadm/phases/01-homebrew.sh` through `04-macos.sh`

## Conventions

- Shell scripts use `#!/bin/sh` with `set -eu` (fail on errors and unset variables)
- ZSH configuration is modular under `.zsh/` (aliases, completion, functions, history, options, plugins, prompt, tools)
- Bootstrap is phase-based: phases 01–03 run automatically, phase 04 (macOS defaults) is opt-in
- All scripts must support both Apple Silicon (`/opt/homebrew`) and Intel (`/usr/local`) Macs
- Tests validate syntax, ShellCheck, Brewfile format, required files, and `set -eu` usage

## Key Directories

- `.zsh/` — modular ZSH configuration files
- `.config/yadm/phases/` — bootstrap phase scripts
- `.config/brew/` — Homebrew Brewfile
- `.local/bin/` — utility scripts (rfv, pre_bootstrap.sh, create_dev_folders.sh)
- `tests/` — test suite
