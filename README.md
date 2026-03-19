# Dotfiles

My macOS development environment, managed with [yadm](https://yadm.io/).

## Fresh Mac Setup

On a brand-new Mac (or after a clean install), run this single command:

```bash
# Personal (full setup: CLI + GUI apps + mackup)
curl -sL https://github.com/LuisMedinaG/.dotfiles/raw/main/.local/bin/pre_bootstrap.sh | sh

# Work (minimal: CLI tools only, no casks, no admin needed)
curl -sL https://github.com/LuisMedinaG/.dotfiles/raw/main/.local/bin/pre_bootstrap.sh | sh -s -- --work
```

Then open a new terminal.

### What that command does

1. Installs **Homebrew** (skips if already installed)
2. Installs **yadm** via Homebrew
3. Clones this repo into your home directory via `yadm clone`
4. Runs the **bootstrap** automatically, which executes three phases:

| Phase | Script | What it does |
|-------|--------|--------------|
| 01 | `01-homebrew.sh` | Installs packages from [Brewfile](.config/brew/Brewfile) or [Brewfile.work](.config/brew/Brewfile.work) |
| 02 | `02-dotfiles.sh` | Checks out dotfiles, pulls latest, inits git submodules |
| 03 | `03-shell.sh` | Installs fzf key bindings, creates required directories |

The `--work` flag selects the minimal `Brewfile.work` (CLI tools only, no casks) and skips mackup setup.

### After bootstrap

**Apply macOS system preferences** (optional — review the file first):

```bash
sh ~/.config/yadm/phases/04-macos.sh
```

This sets developer-friendly defaults: fast key repeat, Finder shows path bar, Dock auto-hides, disable smart quotes, etc. Log out and back in after running.

**Grant macOS permissions** (required for keyboard tools):

| Setting | Apps |
|---------|------|
| Input Monitoring | Karabiner-Elements, Karabiner-EventViewer, kanata |
| Full Disk Access | kanata |
| Accessibility | Karabiner-Elements, Homerow, BetterTouchTool, Raycast |

> **Tip:** When the Finder dialog asks you to locate a binary, press **⌘⇧G** and paste the path (e.g. `/usr/local/bin/kanata`), or run `open -R $(which kanata)` to reveal it in Finder and drag it in.

---

## Re-running phases

Each phase is independent. Run any one without touching the others:

```bash
sh ~/.config/yadm/phases/01-homebrew.sh   # update/install packages only
sh ~/.config/yadm/phases/02-dotfiles.sh   # pull latest dotfiles only
sh ~/.config/yadm/phases/03-shell.sh      # re-setup fzf and directories only
sh ~/.config/yadm/phases/04-macos.sh      # re-apply macOS defaults only
```

Or re-run the full bootstrap (phases 01–03):

```bash
yadm bootstrap
```

---

## What's included

### Shell (ZSH)

```
.zshenv            → env vars, EDITOR, source_if_exists helper
.zprofile          → Homebrew, pyenv (cached), jenv (cached), NVM
.zshrc             → sources everything below:

.zsh/
├── options.zsh    → shell options, keybindings
├── history.zsh    → history settings
├── completion.zsh → tab completion, fzf-tab config, SSH hosts
├── functions.zsh  → lazy NVM, .nvmrc auto-switch, take, reload-ssh,
│                    cache_eval, shell-time, update-all, dotfiles-sync,
│                    karabiner-build
├── aliases.zsh    → ls→eza, cat→bat, grep→rg, vim→nvim
├── prompt.zsh     → minimal prompt with git branch
├── plugins/
│   └── init.zsh   → zinit, zoxide, autosuggestions, syntax-highlighting
└── tools/
    └── fzf.zsh    → fzf defaults, key bindings, tab completion
```

### Packages ([Brewfile](.config/brew/Brewfile))

| CLI tools | Dev tools | Apps |
|-----------|-----------|------|
| bat, eza, fd, fzf, ripgrep | pyenv, jenv | VS Code |
| git, curl, wget, jq, tree | neovim, gh | Chrome |
| zoxide, zsh-abbr, tmux, mackup, kanata | yadm | iTerm2 |
| zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions | | Homerow, Karabiner, Spaceman, BTT |

### Other configs

| Config | Path | Notes |
|--------|------|-------|
| Neovim | `.config/nvim/init.vim` | Beginner-friendly with inline cheat sheet |
| Git | `.gitconfig` | Aliases, rerere, color-moved diffs |
| tmux | `.config/tmux/tmux.conf` | Prefix: Ctrl+Space, true color, mouse |
| Karabiner | `.config/karabiner-config/` | Meh key + leader system ([details](.config/karabiner-config/README.md)) |
| Kanata | `.config/kanata/` | Home-row mods + Fn layer ([details](.config/kanata/README.md)) |
| skhd | `.config/skhd/.skhdrc` | macOS hotkey daemon |
| Raycast | `.config/raycast/` | Extensions and config ([details](.config/raycast/README.md)) |
| Mackup | `.mackup.cfg` + `.mackup/` | Backs up GUI app settings (iTerm2, VS Code, BTT, etc.) |

### Mackup (app settings backup)

[Mackup](https://github.com/lra/mackup) backs up GUI app preferences that live in `~/Library/` — files that are hard to track with yadm directly. Configured to store backups in `.config/mackup/backup/` (git-tracked).

```bash
mackup backup           # back up app settings
mackup backup --force   # skip confirmation prompts
mackup restore          # restore on a new machine
```

Apps tracked: iTerm2, VS Code, Spotify, BetterTouchTool, Homerow, Multitouch, Swish. Custom app definitions live in `.mackup/`. Runs automatically as part of `update-all`.

### Custom functions

| Function | Description |
|----------|-------------|
| `shell-time [n]` | Benchmark zsh startup time (default 10 iterations) |
| `update-all` | Update Homebrew, Zinit plugins, yadm pull, and mackup backup |
| `dotfiles-sync <to-clone\|to-yadm>` | Sync changes between yadm worktree and git clone |
| `karabiner-build` | Build Karabiner config from TypeScript |
| `kanata-reload` | Reload kanata daemon (auto-setup on first run) |
| `take <dir>` | mkdir + cd in one command |
| `activate-venv` | Fuzzy-select a Python virtual environment |
| `reload-ssh` | Reload Yubikey SSH keys |
| `validateYaml <file>` | Validate a YAML file |
| `addToPATH <path>` | Idempotent PATH prepend |
| `cache_eval <name> <cmd> [days]` | Cache eval output (default 7-day TTL) |

### Scripts ([.local/bin/](.local/bin/))

| Script | Usage | What it does |
|--------|-------|--------------|
| `rfv` | `rfv [query]` | Fuzzy search file **contents** (ripgrep + fzf) |
| `rfv -f` | `rfv -f [query] [dir]` | Fuzzy search file **names** (fd + fzf) |
| `create_dev_folders.sh` | `sh create_dev_folders.sh` | Creates standard project directories |

---

## Day-to-day usage

### yadm (works like git)

```bash
yadm add ~/.config/some-app/config
yadm commit -m "Add some-app config"
yadm push
```

### Dual-location workflow

This repo lives in two places: yadm's worktree (`$HOME`) and a git clone at `~/Documents/Projects/.dotfiles`. Use the sync helper to keep them aligned:

```bash
dotfiles-sync to-clone   # copy yadm changes → git clone
dotfiles-sync to-yadm    # copy git clone changes → yadm worktree
```

### Sensitive files

Files listed in `.config/yadm/encrypt` can be encrypted:

```bash
yadm encrypt    # encrypt listed files
yadm decrypt    # decrypt them
```

### Machine-specific configs

Use [yadm alternates](https://yadm.io/docs/alternates) for per-machine overrides:

```bash
# Create a work-specific zshrc
yadm add ~/.zshrc##hostname.work-laptop
yadm alt
```

---

## Performance

pyenv and jenv init output is cached in `~/.cache/zsh/` with a 7-day TTL. NVM is lazy-loaded (only sourced on first `nvm`/`node`/`npm` call). `.nvmrc` files are auto-detected on `cd`.

Clear caches: `rm ~/.cache/zsh/pyenv_init.zsh ~/.cache/zsh/jenv_init.zsh`

Benchmark: `shell-time` (or `shell-time 50` for more iterations)

---

## Testing

### Locally

```bash
sh tests/run_all.sh
```

Checks ZSH syntax, shell script syntax, ShellCheck, Brewfile validation, and common mistakes. Takes a few seconds, installs nothing.

### Docker

```bash
docker build -t dotfiles-test -f Dockerfile.test .
docker run --rm dotfiles-test
```

### CI (GitHub Actions)

Every push to `main` runs three jobs automatically:

| Job | Runner | What it checks |
|-----|--------|----------------|
| Syntax & Lint | Ubuntu | zsh -n, sh -n, shellcheck, common mistakes |
| Brewfile Check | macOS | All packages exist in Homebrew |
| Docker Test | Ubuntu | Builds and runs the test container |

Results at [Actions](../../actions).

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
├── .mackup.cfg                # Mackup config (file_system engine)
├── .mackup/                   # Custom app definitions for Mackup
├── .config/
│   ├── brew/
│   │   ├── Brewfile           # All Homebrew packages (personal)
│   │   └── Brewfile.work      # CLI-only packages (work profile)
│   ├── mackup/backup/         # Mackup app settings storage
│   ├── kanata/                 # Kanata (home-row mods + Fn layer)
│   ├── karabiner-config/       # Karabiner (TypeScript → JSON)
│   ├── nvim/init.vim           # Neovim config
│   ├── raycast/                # Raycast extensions & config
│   ├── skhd/.skhdrc            # Hotkey daemon
│   ├── tmux/tmux.conf          # tmux config
│   └── yadm/
│       ├── bootstrap           # Entry point (calls phases)
│       ├── encrypt             # Encrypted file list
│       └── phases/
│           ├── 01-homebrew.sh  # Install packages
│           ├── 02-dotfiles.sh  # Checkout + submodules
│           ├── 03-shell.sh     # fzf + directories
│           └── 04-macos.sh     # macOS defaults (opt-in)
├── .local/bin/                 # Scripts (rfv, pre_bootstrap.sh)
├── .github/workflows/lint.yml  # CI pipeline
├── tests/run_all.sh            # Test suite
├── Dockerfile.test             # Docker test container
├── .zshenv                     # Environment variables
├── .zprofile                   # Login shell setup
├── .zshrc                      # Interactive shell config
└── .gitconfig                  # Git configuration
```

---

## Credits

- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) — macOS defaults inspiration
- [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles)
