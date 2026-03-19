# Dotfiles — CLAUDE.md

macOS dotfiles managed by [yadm](https://yadm.io/).

## Important: Dual-location Setup

yadm's worktree is `$HOME` — files are deployed there. This repo at `Documents/Projects/.dotfiles` is a separate clone. **Changes must be made in both places** or committed via `yadm` from `$HOME`.

## Quick Reference

- **Run tests:** `sh tests/run_all.sh`
- **Bootstrap:** `yadm bootstrap` (or `sh ~/.config/yadm/bootstrap`)
- **Brewfile:** `.config/brew/Brewfile`

## Conventions

- Shell scripts: `#!/bin/sh` with `set -eu`, no bashisms (`>/dev/null 2>&1` not `&>/dev/null`)
- Support both Apple Silicon (`/opt/homebrew`) and Intel (`/usr/local`)
- Brewfile: non-default taps need `tap` directive + fully-qualified name (e.g., `olets/tap/zsh-abbr`)
- Distinguish `brew` (CLI formulae) vs `cask` (GUI apps) correctly

## ZSH Load Order

`.zshenv` → `.zprofile` (login only) → `.zshrc`

- `.zshenv`: Homebrew shellenv, `$ZSH`, `$EDITOR`, `source_if_exists()` — loaded by ALL shells
- `.zprofile`: `$PATH` additions, pyenv/jenv init, `BREW_COMPLETIONS_PATH` — login shells only
- `.zshrc`: sources `.zsh/` modules in order: options, history, completion, functions, aliases, prompt, tools/fzf, plugins/init

**Non-login shells (tmux, nested) skip `.zprofile`** — anything needed everywhere must be in `.zshenv`.

## Key Directories

- `.zsh/` — modular ZSH config
- `.config/yadm/phases/` — bootstrap phases (01-03 auto, 04 opt-in)
- `.config/brew/` — Brewfile
- `.local/bin/` — utility scripts
- `tests/` — test suite
