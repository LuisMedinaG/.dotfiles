# Dotfiles — CLAUDE.md

Cross-platform dotfiles (macOS personal, macOS work, Linux devbox) managed with [chezmoi](https://www.chezmoi.io/).

## Workflow

chezmoi's source directory is the git repo. Edit files directly in the source dir and apply:

```sh
chezmoi cd              # cd into ~/.local/share/chezmoi (the repo)
# edit files...
chezmoi apply           # deploy changes to $HOME
chezmoi update          # git pull + apply in one step (replaces yadm pull)
```

To add a new file to tracking:

```sh
chezmoi add ~/.config/some-app/config
```

## Quick Reference

- **Run tests:** `bats tests/e2e/`
- **Apply dotfiles:** `chezmoi apply`
- **Update:** `chezmoi update`
- **Brewfile:** `.config/brew/Brewfile`
- **Source repo:** `~/.local/share/chezmoi` (symlinked or cloned by `chezmoi init`)

## Conventions

- Shell scripts: `#!/bin/sh` with `set -eu`, no bashisms (`>/dev/null 2>&1` not `&>/dev/null`)
- Support both Apple Silicon (`/opt/homebrew`) and Intel (`/usr/local`)
- Brewfile: non-default taps need `tap` directive + fully-qualified name (e.g., `olets/tap/zsh-abbr`)
- Distinguish `brew` (CLI formulae) vs `cask` (GUI apps) correctly
- `run_once_` scripts run exactly once (keyed by content hash); `run_onchange_` re-run whenever content changes

## ZSH Load Order

`.zshenv` → `.zprofile` (login only) → `.zshrc`

- `.zshenv`: Homebrew shellenv, `$ZSH`, `$EDITOR`, `source_if_exists()` — loaded by ALL shells
- `.zprofile`: `$PATH` additions, `BREW_COMPLETIONS_PATH` — login shells only
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

Abbreviations (e.g. `ga` → `git add`) live in `~/.config/zsh-abbr/user-abbreviations`.

## Profiles & Setup Scripts

Profile is set in `~/.config/chezmoi/chezmoi.toml` (per-machine, not committed):

```toml
[data]
  dotfiles_profile = "personal"   # or "work" or "linuxbox"
```

| Profile | Scripts run | Use for |
|---|---|---|
| `personal` | 01-homebrew, 03-shell | macOS personal machine |
| `work` | 01-homebrew, 03-shell | macOS work machine (no mackup, no shell-ai) |
| `linuxbox` | 03-shell, 05-linuxbox | Linux dev box |

`run_once_05-linuxbox.sh` installs: **neovim**, **zoxide**, **eza** (from deb.gierens.de). It is idempotent.

## Environment Matrix

### What differs by environment

| Area | macOS personal | macOS work | Linux devbox |
|---|---|---|---|
| **Package manager** | Homebrew | Homebrew | apt |
| **Brewfile** | `Brewfile` (full) | `Brewfile.work` (CLI-only) | — (run_once_05) |
| **GUI apps** | VS Code, Chrome, iTerm2, BTT, Homerow, Karabiner, Spaceman, Lunar, Multitouch | none | none |
| **Keyboard tools** | kanata + karabiner-elements | none | none |
| **App backup** | mackup (via `update-all`) | none | none |
| **shell-ai** | pipx install (run_once_03) | none | pipx install (run_once_05) |
| **macOS defaults** | scripts/04-macos.sh (opt-in) | none | none |
| **Linux packages** | — | — | neovim, zoxide, eza (apt/deb) |

### macOS personal — extras only

- `.config/kanata/` — home-row mods keyboard daemon
- `.config/karabiner-config/` — TypeScript → Karabiner JSON build
- `.config/skhd/.skhdrc` — hotkey daemon
- `.mackup.cfg` + `.mackup/` — app settings backup rules

Functions in `functions.zsh` that are macOS-personal-only:

- `kanata-reload` / `kanata-stop` — manage kanata LaunchDaemon
- `karabiner-build` — build Karabiner config via npm

### Machine-specific overrides (not tracked by chezmoi)

| File | Loaded by | Use for |
|---|---|---|
| `~/.zshenv.local` | All shells (incl. tmux) | Env vars, PATH additions (cargo, go, fnm, uv, etc.) |
| `~/.zprofile.local` | Login shells only | Login-only PATH, version managers |
| `~/.zshrc.local` | Interactive shells | Aliases, functions, company-specific config |
| `~/.aliases.local` | aliases.zsh | Additional aliases |

### Linux-specific ZSH notes

- fzf key-bindings loaded from `/usr/share/doc/fzf/examples/` (apt-installed fzf)
- `Ctrl+G` mapped to `fzf-cd-widget` (Alt+C alternative; works in VS Code terminal / tmux)
- `eza` aliases are guarded with `command -v eza` — safe if not yet installed
- Machine-specific PATH entries (cargo, go, fnm, uv) go in `~/.zshenv.local` / `~/.zshrc.local`

## Key Directories

- `.zsh/` — modular ZSH config
- `scripts/` — opt-in/manual scripts (04-macos.sh, 00-backup.sh)
- `run_onchange_01-homebrew.sh.tmpl` — Homebrew setup (re-runs on Brewfile change)
- `run_once_03-shell.sh.tmpl` — shell setup (fzf, dirs, Zinit)
- `run_once_05-linuxbox.sh` — Linux apt installs
- `.config/brew/` — Brewfile
- `.local/bin/` — utility scripts
- `tests/` — test suite
