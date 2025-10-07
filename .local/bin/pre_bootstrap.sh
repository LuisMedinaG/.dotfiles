#!/bin/sh

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install git

# Create directory if it doesn't exist
mkdir -p ~/.local/bin

# Download yadm
curl -sfLo ~/.local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm

# Give execute permissions to yadm
chmod a+x ~/.local/bin/yadm

# Clone dotfiles repository
~/.local/bin/yadm clone --bootstrap -f https://github.com/LuisMedinaG/macos-config.git

# Clean up by removing yadm
rm -rf ~/.local/bin/yadm

echo "Dotfiles setup completed!"
