# ZSH Configuration

Modular ZSH config sourced by `.zshrc` in this order:

| Module | Purpose |
|--------|---------|
| `options.zsh` | Shell behavior, directory navigation, key bindings (Ctrl+W word boundaries treat `:/.` as separators) |
| `history.zsh` | 10k history, deduplication, shared across sessions |
| `completion.zsh` | Tab completion, fzf-tab integration, SSH host completion from multiple config files |
| `functions.zsh` | Utility functions (see below) |
| `aliases.zsh` | Command replacements: `ls`→eza, `cat`→bat, `grep`→rg, `vim`→nvim, directory stack shortcuts |
| `prompt.zsh` | Minimal prompt with git branch + staged/unstaged indicators |
| `tools/fzf.zsh` | FZF defaults, colors, key bindings, tab completion |
| `plugins/init.zsh` | Zinit plugin manager: fzf-tab, zoxide, autosuggestions, syntax-highlighting |

## Functions

| Function | Description |
|----------|-------------|
| `nvm` / `node` / `npm` | Lazy-loaded wrappers — NVM only sourced on first use |
| `_nvm_auto_use` | Auto `nvm use` when `cd`-ing into a directory with `.nvmrc` |
| `activate-venv` | Fuzzy-select and activate a Python venv from `~/.venv/` |
| `take <dir>` | `mkdir -p` + `cd` |
| `validateYaml <file>` | Validate YAML via Python |
| `karabiner-build` | Build Karabiner config from `~/.config/karabiner-config/` |
| `kanata-reload` | Reload kanata daemon (auto-setup on first run) |
| `shell-time [n]` | Benchmark zsh startup (default 10 iterations) |
| `update-all` | Update Homebrew + Zinit plugins + chezmoi update + mackup backup |

## Adding local overrides

- **Aliases:** Create `~/.aliases.local` (sourced at end of `aliases.zsh`)
- **Functions:** Use `.zshrc.local` or similar via `source_if_exists` in `.zshenv`
