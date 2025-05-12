# macOS Configuration Repository

This repository contains the configuration files (dotfiles) for my macOS environment, managed with YADM (Yet Another Dotfile Manager).

## Applications I Install

These are some of the applications I typically install on a new macOS system:

* iTerm2 / Kitty
* Shortcat
* Dropover
* Obsidian
* Visual Studio Code
* Raycast

Optional:
* Hyperkey / Kanata 
* Raycast Shortcuts / skhd
* Hammerspoon (Mac automations)
* Amaethyst / Yabai

## Setup Instructions for a New Mac

Follow these steps to set up a new macOS machine with my configurations:

### Installation Process

1. **Clone this repository using Git:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/macos-config.git
   cd macos-config
   ```

2. **Run the bootstrap scripts:**
    Run pre-bootstrap.sh first:
    ```bash
    ~/.config/yadm/pre_bootstrap.sh
    ```

   ```bash
   yadm bootstrap
   ```

   The bootstrap process works in two phases:

   **pre_bootstrap.sh:**
   

   **bootstrap:**
   


### What Gets Installed/Configured

The bootstrap process handles installation and configuration of:

- Shell environment (Zsh configuration)
- Homebrew packages via ~/.config/Brewfile
- Keyboard customization (Kanata)
- Hotkey daemon (skhd)
- Window management (if Yabai is selected)
- Terminal configuration
- Git configuration
- Raycast extensions and snippets

### Create Base Development Folders

The bootstrap process automatically runs the development folder creation script:
```bash
~/.local/bin/create_dev_folders.sh
```
This creates a standardized project directory structure.

## Directory Structure

This configuration uses the following structure:

```
~/
├── .config/               # XDG config directory
│   ├── Brewfile          # Homebrew packages list
│   ├── starship.toml     # Starship prompt config
│   ├── .tmux.conf        # Tmux configuration
│   ├── kanata/           # Keyboard customization
│   │   ├── com.lumedina.kanata.plist
│   │   └── kanata.kbd
│   ├── raycast/          # Raycast configurations
│   ├── skhd/             # Keyboard shortcuts
│   │   └── .skhdrc
│   └── yadm/             # YADM-specific files
│       ├── bootstrap     # Main setup script
│       └── pre_bootstrap.sh
├── .local/               # Local binaries and scripts
│   └── bin/
│       └── create_dev_folders.sh
├── .zsh/                 # Modular Zsh configuration
│   ├── aliases.zsh
│   ├── options.zsh
│   └── tools.zsh
├── .gitconfig           # Git configuration
├── .zshenv              # Zsh environment variables
└── .zshrc               # Main Zsh configuration
```

## YADM Usage

After the initial setup, you'll interact with your dotfiles using YADM commands:

### Adding New Dotfiles

```bash
yadm add ~/.config/some-new-app/config
yadm commit -m "Add configuration for some-new-app"
yadm push
```

### Updating Configurations

After making changes to any configuration file:

```bash
yadm status
yadm add [changed files]
yadm commit -m "Update configuration for XYZ"
yadm push
```

### Syncing Changes to Another Mac

On your other Mac that already has YADM set up:

```bash
yadm pull
```

### Using Alternate Files for Different Machines

For machine-specific configurations:

```bash
# Create a file with machine-specific modifications
yadm add ~/.zshrc##hostname.work

# List alternate files
yadm alt
```

## Customization

To customize this setup for your own use:

1. Fork this repository
2. Modify the configurations as needed
3. Update the bootstrap script to match your requirements
4. Update the Brewfile with your preferred applications
