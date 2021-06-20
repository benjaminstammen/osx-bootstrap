#!/usr/bin/env bash
# 
# Bootstrap script for setting up a new OSX machine
# 
# This should be idempotent so it can be run multiple times.
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
# - Script (and docs) heavily based on gist:
#   https://gist.github.com/codeinthehole/26b37efa67041e1307db
#
echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

PACKAGES=(
    git
    gsed
    imagemagick
    jq
    mono
    neovim
    pyenv
    rbenv
    ripgrep
    wget
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

CASKS=(
    chromium
    docker
    godot
    godot-mono
    obsidian
    intellij-idea-ce
    iterm2
    little-snitch
    slack
    spotify
    sublime-text
    vlc
    vscodium
    homebrew/cask-versions/firefox-developer-edition
)

echo "Installing cask apps..."
brew install --cask ${CASKS[@]}

echo "Configuring OSX..."

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Creating folder structure..."
[[ ! -d ~/Source ]] && mkdir ~/Source

echo "Configuring Firefox..."
./firefox/set-up-firefox-profile.sh benjamin

echo "Bootstrapping complete"
