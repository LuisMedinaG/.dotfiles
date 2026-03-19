# Work MacBook Setup

Minimal dotfiles profile for a restricted work MacBook — CLI tools only, no admin required.

## Quick Setup

If Homebrew and yadm are already installed:

```bash
yadm clone https://github.com/LuisMedinaG/.dotfiles.git --bootstrap
# When prompted, run:
sh ~/.config/yadm/bootstrap-work
```

If starting from scratch:

```bash
# 1. Install Homebrew (may need IT approval)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install yadm
brew install yadm

# 3. Clone and bootstrap
yadm clone https://github.com/LuisMedinaG/.dotfiles.git --no-bootstrap
sh ~/.config/yadm/bootstrap-work
```

## What gets installed

### CLI tools (via `Brewfile.work`)

All formula-only — no casks, nothing requiring admin permissions:

| Tool | Replaces | Why |
|------|----------|-----|
| eza | ls | Icons, colors, git status |
| bat | cat | Syntax highlighting |
| ripgrep | grep | Faster, smarter search |
| fd | find | Simpler syntax, respects .gitignore |
| fzf | — | Fuzzy finder for files, history, completions |
| zoxide | cd | Learns your most-used directories |
| neovim | vim | Better terminal editor |
| tmux | — | Terminal multiplexer |
| gh | — | GitHub CLI |

### Shell config (transfers as-is)

The entire ZSH config works without changes — all Homebrew-dependent parts are guarded:

- `source_if_exists` skips missing files silently
- `command -v` checks before using pyenv/jenv/zoxide
- `[ -n "$HOMEBREW_PREFIX" ]` guards Homebrew-specific paths
- Aliases (`eza`, `bat`, `rg`) work when the tools are installed, error harmlessly if not

### What's excluded

| Feature | Why |
|---------|-----|
| Cask apps (Karabiner, iTerm2, etc.) | Require admin / IT approval |
| macOS defaults (phase 04) | Some need admin, may conflict with IT policy |
| Karabiner config | No Karabiner installed |
| skhd | Needs Accessibility permissions |

## Post-install: Git identity

Your `.gitconfig` ships with your personal email. Override for work:

### Option A: Global override (simplest)

```bash
git config --global user.email "luis.medina@company.com"
```

### Option B: Directory-based (keep both identities)

Add to `~/.gitconfig`:

```gitconfig
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
```

Create `~/.gitconfig-work`:

```gitconfig
[user]
    email = luis.medina@company.com
```

Now any repo under `~/work/` automatically uses your work email.

## Adding work-specific tools later

```bash
# Edit the work Brewfile
vim ~/.config/brew/Brewfile.work

# Re-run just the Homebrew phase
sh ~/.config/yadm/phases/01-homebrew-work.sh
```

## If Homebrew can't be installed

The shell config still works — you just won't get the modern CLI replacements. The aliases will fail silently, and you'll use the default `ls`, `cat`, `grep`, etc. Zinit plugins (autosuggestions, syntax-highlighting, fzf-tab) install from GitHub and don't need Homebrew.
