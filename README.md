# 🚀 Dotfiles: macOS Development Environment

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
![YADM](https://img.shields.io/badge/manager-YADM-red.svg)

A modern, modular dotfiles configuration for macOS development environments, optimized for performance and maintainability. Managed with YADM (Yet Another Dotfiles Manager).

## ✨ Features

- **Optimized ZSH Configuration**: Modular organization with performance enhancements
- **Smart Completions**: Intelligent tab completion including SSH hosts
- **Fast Shell Startup**: Lazy-loading for NVM and other tools
- **Environment Isolation**: Work vs personal environment separation using YADM classes
- **Development Tooling**: Configured for Git, Python, Node.js, Java, and more
- **Terminal Utilities**: FZF integration, convenient aliases, and functions

## 🔧 System Requirements

- [Homebrew](https://brew.sh/)
- Xcode Command Line Tools (will be installed by homebrew)

### Pre-Installation
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
To install yadm temporarily, then clone the .dotfiles repo and bootstrap the system, run the following command:

```bash
curl -sL https://github.com/marcogreiveldinger/.dotfiles/raw/main/pre_bootstrap.sh | bash
```

## 📦 Installation

### Quick Install

```bash
# Pre-Bootstrap: Sets up Brew and YADM
~/.config/yadm/pre_bootstrap.sh

# Install YADM if not already installed
brew install yadm

# Clone the repository
yadm clone https://github.com/YOUR_USERNAME/dotfiles.git

# Run the bootstrap script
yadm bootstrap
```

## 📂 Directory Structure

```bash
~/
├── .zsh/                 # ZSH configuration (modular)
│   ├── aliases.zsh       # Command aliases
│   ├── completion.zsh    # Tab completion setup
│   ├── exports.zsh       # Environment variables 
│   ├── functions.zsh     # Shell functions
│   ├── history.zsh       # History configuration
│   ├── options.zsh       # ZSH options
│   ├── prompt.zsh        # Shell prompt configuration
│   ├── plugins/          # ZSH plugins
│   │   └── init.zsh      # Plugin loader
│   └── tools/            # Tool configurations
│       └── fzf.zsh       # FZF integration
├── .config/              # XDG config directory
│   ├── brew/             # Homebrew
│   │   ├── Brewfile      # Package list
│   │   └── install.sh    # Installer
│   ├── git/              # Git configuration
│   ├── kanata/           # Keyboard customization
│   ├── nvim/             # Neovim config
│   ├── raycast/          # Raycast settings
│   ├── skhd/             # Keyboard shortcuts
│   ├── tmux/             # Terminal multiplexer
│   └── yadm/             # YADM-specific files
│       ├── bootstrap     # Main setup script
│       └── encrypt       # Encryption config
├── .local/bin/           # Local executable scripts
├── .zshenv               # ZSH environment loader
├── .zprofile             # Login shell configuration
├── .zshrc                # Interactive shell config
└── .gitconfig            # Git configuration
```

## 🖥️ Applications & Tools

### Core Tools
- **Shell**: ZSH with custom configuration
- **Terminal**: iTerm2 or Kitty
- **Editor**: Visual Studio Code / Neovim
- **Search**: FZF + Ripgrep
- **File Manager**: Finder + command line tools

# Recommended Applications

| Category | Applications |
|----------|--------------|
| **Productivity** | Raycast, Obsidian, Dropover |
| **Development** | VS Code, iTerm2/Kitty, Git |
| **Keyboard** | Kanata (key remapping), skhd (hotkeys) |
| **Window Management** | Amethyst/Yabai |
| **Automation** | Hammerspoon |

The bootstrap process handles installation and configuration tools & applications:

## YADM Usage

After the initial setup, you'll interact with your dotfiles using YADM commands:

### Adding New Dotfiles

```bash
yadm add ~/.config/some-new-app/config
yadm commit -m "Add configuration for some-new-app"
yadm push
```

### Using Alternate Files for Different Machines

For machine-specific configurations:

```bash
# Create a file with machine-specific modifications
yadm add ~/.zshrc##hostname.work

# List alternate files
yadm alt
```

### Encryption for Sensitive Data
```bash
# Edit encryption configuration
yadm encrypt

# Decrypt files
yadm decrypt
```

## Customization

To customize this setup for your own use:

1. Fork this repository
2. Modify the configurations as needed
3. Update the bootstrap script to match your requirements
4. Update the Brewfile with your preferred applications

## 📜 Credits & Acknowledgments
This configuration draws inspiration from:

- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles)
