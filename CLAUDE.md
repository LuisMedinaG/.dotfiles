# Dotfiles — CLAUDE.md

Cross-platform dotfiles (macOS personal, macOS work, Linux devbox) managed with [yadm](https://yadm.io/).

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

## Environment Matrix

The goal is maximum sharing with minimal divergence. All three environments run the same ZSH config — platform differences are handled by runtime guards, not separate files.

### Shared across all environments

| Area | What's shared |
|---|---|
| ZSH config | All `.zsh/` modules — options, history, completion, functions, aliases, prompt |
| Plugins | Zinit self-installs from GitHub; same 5 plugins on all platforms |
| Core CLI | `bat`, `eza`, `fd`, `fzf`, `ripgrep`, `neovim`, `git`, `curl`, `wget`, `jq`, `tree`, `gh`, `tmux`, `zoxide` |
| Editor | neovim + `.config/nvim/init.vim` |
| Multiplexer | tmux + `.config/tmux/tmux.conf` |
| Git | `.gitconfig` (override email via `~/.gitconfig-work` or `~/.gitconfig-linux`) |
| Guards | Aliases for `eza`, `nvim` use `command -v` — safe if tool is absent |

### What differs by environment

| Area | macOS personal | macOS work | Linux devbox |
|---|---|---|---|
| **Package manager** | Homebrew | Homebrew | apt |
| **Brewfile** | `Brewfile` (full) | `Brewfile.work` (CLI-only) | — (phase 05) |
| **GUI apps** | VS Code, Chrome, iTerm2, BTT, Homerow, Karabiner, Spaceman, Lunar, Multitouch | none | none |
| **Keyboard tools** | kanata + karabiner-elements | none | none |
| **App backup** | mackup (runs in bootstrap + `update-all`) | none | none |
| **shell-ai** | pipx install (phase 03) | none | pipx install (phase 05) |
| **macOS defaults** | phase 04 (opt-in) | none | none |
| **Linux packages** | — | — | neovim, zoxide, eza (apt/deb) |
| **fzf bindings** | `$HOMEBREW_PREFIX/opt/fzf/shell/` | `$HOMEBREW_PREFIX/opt/fzf/shell/` | `/usr/share/doc/fzf/examples/` |
| **Clone path** | `~/Documents/Projects/.dotfiles` | `~/Documents/Projects/.dotfiles` | `~/projects/.dotfiles` |

### macOS personal — extras only

Files tracked by yadm that are only meaningful on a personal Mac:

- `.config/kanata/` — home-row mods keyboard daemon
- `.config/karabiner-config/` — TypeScript → Karabiner JSON build
- `.config/skhd/.skhdrc` — hotkey daemon
- `.config/raycast/` — launcher config
- `.mackup.cfg` + `.mackup/` — app settings backup rules

Functions in `functions.zsh` that are macOS-personal-only (no-ops on other envs — they reference `launchctl` and `npm` paths that won't exist):

- `kanata-reload` / `kanata-stop` — manage kanata LaunchDaemon
- `karabiner-build` — build Karabiner config via npm

### Machine-specific overrides (not tracked by yadm)

Put anything machine-specific in `.local` files — sourced automatically, never committed:

| File | Loaded by | Use for |
|---|---|---|
| `~/.zshenv.local` | All shells (incl. tmux) | Env vars, PATH additions (cargo, go, fnm, uv, etc.) |
| `~/.zprofile.local` | Login shells only | pyenv/jenv overrides, login-only PATH |
| `~/.zshrc.local` | Interactive shells | Aliases, functions, company-specific config |
| `~/.aliases.local` | aliases.zsh | Additional aliases |

### Linux-specific ZSH notes

- fzf key-bindings loaded from `/usr/share/doc/fzf/examples/` (apt-installed fzf)
- `Ctrl+G` mapped to `fzf-cd-widget` (Alt+C alternative; works in VS Code terminal / tmux)
- `eza` aliases are guarded with `command -v eza` — safe if not yet installed
- Machine-specific PATH entries (cargo, go, fnm, uv) go in `~/.zshenv.local` / `~/.zshrc.local`
- `update-all` calls `brew` — on Linux, run zinit/yadm updates manually or add overrides in `~/.zshrc.local`

## Key Directories

- `.zsh/` — modular ZSH config
- `.config/yadm/phases/` — bootstrap phases (01–03 auto, 04 opt-in macOS, 05 linuxbox)
- `.config/brew/` — Brewfile
- `.local/bin/` — utility scripts
- `tests/` — test suite
