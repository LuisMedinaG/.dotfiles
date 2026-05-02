# Dotfiles — CLAUDE.md

macOS dotfiles managed by [yadm](https://yadm.io/).

## Important: Repo-only Workflow

yadm's worktree is `$HOME`, but **this repo at `~/projects/dotfiles` (Linux) / `~/Documents/Projects/.dotfiles` (macOS) is the source of truth**. All edits happen here. Do **not** edit files directly in `$HOME` — those are treated as deployed artifacts and may be reset.

Workflow:

1. Edit files in this repo (`~/Documents/Projects/.dotfiles/...`).
2. Commit and push from the repo.
3. Deploy to `$HOME` with `yadm pull` (on this machine or any other).

If the yadm worktree in `$HOME` has drifted from HEAD, reset it:

```sh
yadm restore .    # discard local changes in $HOME
yadm pull         # fast-forward to latest
```

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

## Plugin Architecture

Plugins are managed by **Zinit** (`.zsh/plugins/init.zsh`), which self-installs from GitHub on first `exec zsh`. No Homebrew or apt packages needed for plugins.

| Plugin | Purpose | Load constraint |
|---|---|---|
| `djui/alias-tips` | Reminds you when an alias exists | — |
| `Aloxaf/fzf-tab` | Replaces zsh completion menu with fzf | after compinit |
| `olets/zsh-abbr` | Fish-style expanding abbreviations | before syntax-highlighting |
| `zsh-users/zsh-autosuggestions` | Grey as-you-type suggestions | — |
| `zsh-users/zsh-syntax-highlighting` | Colors valid/invalid commands | **must be last** |

Abbreviations (e.g. `ga` → `git add`) live in `~/.config/zsh-abbr/user-abbreviations`. They are not tracked by yadm — machine-local.

macOS previously sourced autosuggestions/syntax-highlighting from Homebrew paths. Those were removed in favor of `zinit light` so both platforms use the same code path.

## Profiles & Bootstrap

Bootstrap profiles are selected during `yadm bootstrap`:

| Profile | Phases run | Use for |
|---|---|---|
| `personal` | 01–03, mackup restore | macOS personal machine |
| `work` | 01–03 | macOS work machine (no mackup) |
| `linuxbox` | 01–03, 05 | Linux dev box |

Phase 05 (`phases/05-linuxbox.sh`) installs: **neovim**, **zoxide**, **eza** (from deb.gierens.de). It is idempotent.

### Linux-specific ZSH notes

- fzf key-bindings loaded from `/usr/share/doc/fzf/examples/` (apt-installed fzf)
- `Ctrl+G` mapped to `fzf-cd-widget` (Alt+C alternative; works in VS Code terminal / tmux)
- eza aliases are guarded with `command -v eza` — safe if eza isn't installed yet
- Machine-specific PATH entries (cargo, go, fnm, uv) go in `~/.zshenv.local` / `~/.zshrc.local` — sourced via `source_if_exists`, never tracked by yadm

## Key Directories

- `.zsh/` — modular ZSH config
- `.config/yadm/phases/` — bootstrap phases (01–03 auto, 04 opt-in macOS, 05 linuxbox)
- `.config/brew/` — Brewfile
- `.local/bin/` — utility scripts
- `tests/` — test suite
