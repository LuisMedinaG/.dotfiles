# macOS Configuration Repository

This repository contains the configuration files for my macOS environment.

## Applications I Install

These are some of the applications I typically install on a new macOS system:

* iTerm2 / Kitty
* Shortcat
* Dropover
* Obsidian
* Visual Studio Code
* Raycast

Optional
* Hyperkey / Kanata 
* Raycast Shortcuts / skskhd
* Hammerspoon (Mac automations)
* Amaethyst / Yabai


## Setup Instructions for a New Laptop

Follow these steps to set up your new macOS laptop with my configurations:

### Prerequisites

1.  **Install Homebrew:** If Homebrew is not already installed, open Terminal and run:
    ```bash
    /bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"
    ```
    Follow the on-screen instructions.

2.  **Install Git:** Ensure Git is installed (it usually is by default on macOS, but you can check with `git --version`). If not, install it via Homebrew:
    ```bash
    brew install git
    ```

3.  **Install Essential Applications:** Install the applications you typically use via Homebrew (if available) or by downloading them:
    ```bash
    brew install iterm2
    brew install --cask dropover  # For cask apps
    brew install --cask obsidian
    brew install --cask visual-studio-code
    brew install --cask raycast
    # Shortcat is often downloaded from its website
    ```

### Installation

1.  **Clone this repository:** Open Terminal and navigate to a directory where you want to clone this repository (e.g., your home directory):
    ```bash
    cd ~
    git clone <repository_url> macos-config
    cd macos-config
    ```
    *(Replace `<repository_url>` with the actual URL of your repository.)*

2.  **Install Required Applications:** Use Homebrew to install the core configuration tools:
    ```bash
    brew install kanata
    brew install koekeishiya/formulae/skhd
    brew install koekeishiya/formulae/yabai
    ```

3.  **Create Symbolic Links (Symlinks):** This step will link the configuration files in this repository to their expected locations in your home directory. Run the following commands in the Terminal (while inside the `macos-config` directory):

    ```bash
    mkdir -p ~/.zsh
    ln -sf "$(pwd)/dotfiles/zsh/.zshrc" ~/.zshrc
    ln -sf "$(pwd)/dotfiles/zsh/.zshenv" ~/.zshenv

    mkdir -p ~/.config/skhd
    ln -sf "$(pwd)/dotfiles/skhd/.skhdrc" ~/.config/skhd/.skhdrc

    mkdir -p ~/.config/yabai
    ln -sf "$(pwd)/dotfiles/yabai/.yabairc" ~/.config/yabai/.yabairc

    mkdir -p ~/.config/kanata
    ln -sf "$(pwd)/dotfiles/kanata/your_kanata_config.kbd" ~/.config/kanata/your_kanata_config.kbd

    # Add more symlinks for other dotfiles as needed
    # For example:
    # mkdir -p ~/.config/nvim
    # ln -sf "$(pwd)/dotfiles/nvim/init.vim" ~/.config/nvim/init.vim
    ```

4.  **Start Services:** You might need to manually start the `skhd` and `yabai` services or configure them to start on login. Refer to their respective documentation for the recommended way to do this (often involves `launchctl`).

5.  **Apply Kanata Configuration:** Start the Kanata service to apply your keyboard layout. The exact command might depend on your Kanata setup.

### Create Base Development Folders (Optional)

For software developers, you can run the provided script to create a basic folder structure in your home directory:

```bash
cd macos-config/scripts
./create_dev_folders.sh

6. Raycast Snipets
