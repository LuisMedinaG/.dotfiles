# Dotfiles

Cross-platform development environment (macOS personal, macOS work, Linux devbox) managed with [chezmoi](https://www.chezmoi.io/). All three environments share the same ZSH config — differences are handled by runtime guards and a per-machine profile.

## Setup

### macOS (personal or work)

On a brand-new Mac:

```bash
# Personal (full setup: CLI + GUI apps + mackup)
curl -sL https://github.com/LuisMedinaG/.dotfiles/raw/main/.local/bin/pre_bootstrap.sh | sh

# Work (CLI tools only, no casks)
curl -sL https://github.com/LuisMedinaG/.dotfiles/raw/main/.local/bin/pre_bootstrap.sh | sh -s -- --work
```

**What that command does:**

1. Installs **Homebrew** (skips if already installed)
2. Installs **chezmoi** via Homebrew
3. Writes `~/.config/chezmoi/chezmoi.toml` with the chosen profile
4. Runs `chezmoi init --apply` — clones the repo, applies all dotfiles, and runs setup scripts:

| Script | What it does |
|--------|--------------|
| `run_onchange_01-homebrew.sh.tmpl` | Installs packages from Brewfile (re-runs if Brewfile changes) |
| `run_once_03-shell.sh.tmpl` | Installs fzf key bindings, creates required directories, pre-clones Zinit |

### Linux devbox

On a fresh Ubuntu/Debian machine:

```bash
# 1. Install curl if needed
sudo apt-get install -y curl

# 2. Run pre_bootstrap with linuxbox profile
curl -sL https://github.com/LuisMedinaG/.dotfiles/raw/main/.local/bin/pre_bootstrap.sh | sh -s -- --linuxbox
```

This installs chezmoi, applies dotfiles, runs shell setup, and `run_once_05-linuxbox.sh` which installs via apt: **neovim**, **zoxide**, **eza** (from deb.gierens.de), **pipx**, **shell-ai**.

### After setup (all platforms)

Open a new terminal. Zinit installs its plugins on the first interactive shell start.

Move machine-specific config into `.local` files (not tracked by chezmoi):

| File | Loaded by | Use for |
|------|-----------|---------|
| `~/.zshenv.local` | All shells (incl. tmux) | Env vars, PATH additions |
| `~/.zprofile.local` | Login shells only | Login-only PATH, version managers |
| `~/.zshrc.local` | Interactive shells | Aliases, functions, company-specific config |

**macOS personal — additional steps:**

Apply macOS system preferences (optional — review the file first):

```bash
sh "$(chezmoi source-path)/scripts/04-macos.sh"
```

Grant permissions for keyboard tools:

| Setting | Apps |
|---------|------|
| Input Monitoring | Karabiner-Elements, Karabiner-EventViewer, kanata |
| Full Disk Access | kanata |
| Accessibility | Karabiner-Elements, Homerow, BetterTouchTool, Raycast |

---

## Environment comparison

| | macOS personal | macOS work | Linux devbox |
|---|---|---|---|
| **Profile** | `personal` | `work` | `linuxbox` |
| **Package manager** | Homebrew | Homebrew | apt |
| **Packages** | [Brewfile](.config/brew/Brewfile) | [Brewfile.work](.config/brew/Brewfile.work) | run_once_05 (apt) |
| **GUI apps** | VS Code, Chrome, iTerm2, BTT, Homerow, Karabiner, Spaceman, Lunar | none | none |
| **Keyboard remapping** | kanata + karabiner-elements | none | none |
| **App settings backup** | mackup | none | none |
| **macOS defaults** | opt-in (scripts/04-macos.sh) | none | none |
| **ZSH config** | shared | shared | shared |
| **Zinit plugins** | shared (GitHub) | shared (GitHub) | shared (GitHub) |

**Core CLI tools on all three:** `bat`, `eza`, `fd`, `fzf`, `ripgrep`, `neovim`, `git`, `curl`, `jq`, `gh`, `tmux`, `zoxide`

---

## Day-to-day usage

### chezmoi (works like git, but for dotfiles)

```bash
chezmoi add ~/.config/some-app/config   # track a new file
chezmoi edit ~/.zshrc                   # edit a tracked file
chezmoi apply                           # apply source → $HOME
chezmoi diff                            # preview changes
chezmoi update                          # git pull + apply in one step
chezmoi cd                              # cd into the source repo
```

The source repo lives at `~/.local/share/chezmoi` (or wherever `chezmoi source-path` points). Edit files there and run `chezmoi apply` — no sync step needed.

### Machine-specific configs

Use `.local` files for machine-specific overrides (not tracked by chezmoi):

```bash
~/.zshenv.local      # env vars, PATH — loaded by ALL shells
~/.zprofile.local    # login-shell overrides
~/.zshrc.local       # aliases, functions, interactive config
```

### Re-running setup scripts

chezmoi re-runs `run_onchange_` scripts automatically when their content (including embedded Brewfile checksums) changes. For `run_once_` scripts, force a re-run by removing the state entry:

```bash
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

Or run them directly:

```bash
sh run_onchange_01-homebrew.sh.tmpl    # won't work — needs template rendering
chezmoi execute-template < run_onchange_01-homebrew.sh.tmpl | sh
```

---

## What's included

### Shell (ZSH)

```
.zshenv            → env vars, EDITOR, source_if_exists helper → .zshenv.local
.zprofile          → Homebrew PATH, NVM dir → .zprofile.local
.zshrc             → sources everything below → .zshrc.local:

.zsh/
├── options.zsh    → shell options, keybindings
├── history.zsh    → history settings
├── completion.zsh → tab completion, fzf-tab config, SSH hosts
├── functions.zsh  → lazy NVM, .nvmrc auto-switch, take, activate-venv,
│                    shell-time, update-all, karabiner-build
├── aliases.zsh    → ls→eza, cat→bat, grep→rg, vim→nvim
├── prompt.zsh     → minimal prompt with git branch
├── plugins/
│   └── init.zsh   → zinit, zoxide, autosuggestions, syntax-highlighting
└── tools/
    └── fzf.zsh    → fzf defaults, key bindings, tab completion
```

### Packages

**Shared core** (all three environments):

| CLI | Dev |
|-----|-----|
| bat, eza, fd, fzf, ripgrep | neovim, gh |
| git, curl, wget, jq, tree | tmux, zoxide |

**macOS personal adds** ([Brewfile](.config/brew/Brewfile)): `kanata`, `mackup`, and GUI casks (VS Code, Chrome, iTerm2, Homerow, Karabiner-Elements, BetterTouchTool, Multitouch, Spaceman, Lunar).

**macOS work** ([Brewfile.work](.config/brew/Brewfile.work)): core CLI only, no casks.

**Linux devbox** (run_once_05 apt): `neovim`, `eza`, `zoxide`. Install `bat` and `ripgrep` via apt to enable their aliases.

### Other configs

| Config | Path | Notes |
|--------|------|-------|
| Neovim | `.config/nvim/init.vim` | Beginner-friendly with inline cheat sheet |
| Git | `.gitconfig` | Aliases, rerere, color-moved diffs |
| tmux | `.config/tmux/tmux.conf` | Prefix: Ctrl+Space, true color, mouse |
| Karabiner | `.config/karabiner-config/` | Meh key + leader system ([details](.config/karabiner-config/README.md)) |
| Kanata | `.config/kanata/` | Home-row mods + Fn layer ([details](.config/kanata/README.md)) |
| skhd | `.config/skhd/.skhdrc` | macOS hotkey daemon |
| Mackup | `.mackup.cfg` + `.mackup/` | Backs up GUI app settings (iTerm2, VS Code, BTT, etc.) |

### Custom functions

| Function | Description |
|----------|-------------|
| `shell-time [n]` | Benchmark zsh startup time (default 10 iterations) |
| `update-all` | Update Homebrew, Zinit plugins, chezmoi update, and mackup backup |
| `karabiner-build` | Build Karabiner config from TypeScript |
| `kanata-reload` | Reload kanata daemon (auto-setup on first run) |
| `take <dir>` | mkdir + cd in one command |
| `activate-venv` | Fuzzy-select a Python virtual environment |
| `validateYaml <file>` | Validate a YAML file |

### Scripts ([.local/bin/](.local/bin/))

| Script | Usage | What it does |
|--------|-------|--------------|
| `rfv` | `rfv [query]` | Fuzzy search file **contents** (ripgrep + fzf) |
| `rfv -f` | `rfv -f [query] [dir]` | Fuzzy search file **names** (fd + fzf) |
| `create_dev_folders.sh` | `sh create_dev_folders.sh` | Creates standard project directories |

---

## Testing

```bash
bats tests/e2e/
```

CI runs on every push: shell lint (zsh -n + shellcheck), bats e2e suite, Brewfile validation on macOS, and a gitleaks secret scan. See [Actions](../../actions).

---

## Directory structure

```
~/
├── .zsh/                      # ZSH config (modular)
│   ├── aliases.zsh
│   ├── completion.zsh
│   ├── functions.zsh
│   ├── history.zsh
│   ├── options.zsh
│   ├── prompt.zsh
│   ├── plugins/init.zsh       # Plugin manager + plugins
│   └── tools/fzf.zsh          # FZF configuration
├── .mackup.cfg                # Mackup config
├── .mackup/                   # Custom app definitions for Mackup
├── .config/
│   ├── brew/
│   │   ├── Brewfile           # All Homebrew packages (personal)
│   │   └── Brewfile.work      # CLI-only packages (work profile)
│   ├── kanata/                 # Kanata (home-row mods + Fn layer)
│   ├── karabiner-config/       # Karabiner (TypeScript → JSON)
│   ├── nvim/init.vim           # Neovim config
│   ├── skhd/.skhdrc            # Hotkey daemon
│   ├── tmux/tmux.conf          # tmux config
│   └── zsh-abbr/               # zsh-abbr abbreviations
├── .local/bin/                 # Scripts (rfv, pre_bootstrap.sh)
├── .chezmoiignore              # Files not deployed to $HOME
├── run_onchange_01-homebrew.sh.tmpl  # Homebrew setup (re-runs on Brewfile change)
├── run_once_03-shell.sh.tmpl         # Shell setup (fzf, dirs, Zinit)
├── run_once_05-linuxbox.sh           # Linux apt installs
├── scripts/
│   ├── 00-backup.sh            # Backup existing dotfiles (manual)
│   └── 04-macos.sh             # macOS defaults (opt-in, manual)
├── .github/workflows/ci.yml    # CI pipeline
├── tests/e2e/                  # Bats test suite
├── .zshenv                     # Environment variables
├── .zprofile                   # Login shell setup
├── .zshrc                      # Interactive shell config
└── .gitconfig                  # Git configuration
```

---

## Credits

- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) — macOS defaults inspiration
- [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles)
