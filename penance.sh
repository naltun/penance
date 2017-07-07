#!/bin/sh
# PENANCE aims to be a POSIX-compliant, OS-neutral script for installing and configuring the wonderful Exercism CLI tool
# NOTE: Adherence to OS-agnosticism will not manifest until further releases
#
# This script is released under the very liberal MIT licence
# Created by Noah Altunian (github.com/naltun)
#
# NOTE: Currently this script only supports GNU Bash -- This will be changed

# Exit immediately if a command exits with a non-zero status
set -e

echo "Beginning Exercism CLI installation..."

# Check architecture and set URL for download, as well as tarball file name
ARCH=$(uname -m)
echo "Your architecture is $ARCH"
case "$ARCH" in
    'i386')
        ARCH_URL="https://github.com/exercism/cli/releases/download/v2.4.1/exercism-linux-32bit.tgz"
        TARBALL="exercism-linux-32bit.tgz"
        ;;
    'x86_64')
        ARCH_URL="https://github.com/exercism/cli/releases/download/v2.4.1/exercism-linux-64bit.tgz"
        TARBALL="exercism-linux-64bit.tgz"
        ;;
    *)
        echo "Your architecture is currently not supported by this script. Exiting."
        exit 1
        ;;
esac

# Download the Exercism tarball
echo "Downloading your architecture's tarball..."
wget --quiet --show-progress $ARCH_URL

# Extract tarball, then remove it
echo "Extracting tarball..."
tar -xzf $TARBALL
echo "Removing tarball..."
rm $TARBALL

# Check to see if $HOME/bin exists; if not, make $HOME/bin directory
if [ -d "$HOME/bin" ]; then
    echo "Skipping $HOME/bin setup..."
else
    echo "Setting up $HOME/bin directory..."
    mkdir ~/bin
fi

# Move binary into $HOME/bin
echo "Moving exercism binary into directory..."
mv exercism "$HOME/bin"

# Export binary path, including to .bashrc
echo "Exporting path to binary..."
export PATH=$HOME/bin:$PATH
echo "Adding binary path to shell config..."
echo "export PATH=$HOME/bin:$PATH" >> ~/.bashrc

# Verify that the installation was successful; if not, exit with status of 1
echo "Verifying exercism installation..."
if [ ! -x "$(command -v exercism)" ]; then
    echo "Exercism did not install successfully. Exiting."; exit 1
fi

# Add autocompletion for binary
echo "Downloading and executing autocompletion script..."
mkdir -p ~/.config/exercism/
curl --silent http://cli.exercism.io/exercism_completion.bash > ~/.config/exercism/exercism_completion.bash

# Add autocompletion .bash file and execute
if [ -f ~/.config/exercism/exercism_completion.bash ]; then
    . ~/.config/exercism/exercism_completion.bash
fi

# Blank lines on 78 and 80 for readability
echo ""
echo "Everything has been successfully installed."
echo ""
echo "You are all done :) Make sure to set your API key by running:"
echo "exercism configure --key=YOUR_API_KEY"
echo "Goodbye"
exit 0
