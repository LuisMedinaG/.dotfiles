# ZSH Configuration

Modular ZSH config sourced by `.zshrc` in this order:

| Module | Purpose |
|--------|---------|
| `options.zsh` | Shell behavior, directory navigation, key bindings (Ctrl+W word boundaries treat `:/.` as separators) |
| `history.zsh` | 50,000 history entries, deduplication, shared across sessions |
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
| `kanata-reload` | Install root-owned Kanata snapshots and restart the system daemon |
| `shell-time [n]` | Benchmark zsh startup (default 10 iterations) |
| `update-all` | Update Homebrew + Zinit plugins + yadm pull + mackup backup |
| `dotfiles-sync <to-clone\|to-yadm>` | Sync between yadm worktree and git clone |

Run `kanata-reload` with admin credentials after changing the Kanata config or upgrading the binary.
It copies the binary from PATH and the config from `~/.config/kanata/kanata.kbd` into `/Library/Kanata`.

Run the regression tests with `bats ~/.zsh/tests/regression.bats`.

## Adding local overrides

- **Aliases:** Create `~/.aliases.local` (sourced at end of `aliases.zsh`)
- **Functions:** Use `.zshrc.local` or similar via `source_if_exists` in `.zshenv`
