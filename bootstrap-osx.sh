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
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update homebrew recipes
brew update

PACKAGES=(
    coreutils
    git
    gpg
    graphviz
    gsed
    imagemagick
    jq
    libmemcached
    maven
    neovim
    openjdk@8
    openjdk@11
    postgresql
    pyenv
    rbenv
    ripgrep
    rsync
    wget
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

CASKS=(
    chromium
    docker
    obsidian
    intellij-idea-ce
    iterm2
    little-snitch
    slack
    spotify
    sublime-text
    visual-studio-code
    vlc
    homebrew/cask-versions/firefox-developer-edition
)

echo "Installing cask apps..."
brew install --cask ${CASKS[@]}

echo "Configuring pyenv..."
pyenv install 3.9.7
pyenv global 3.9.7

echo "Installing oh-my-zsh"
# Installer is idempotent
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Configuring OSX..."
# Some of these commands seem to require a logout to take effect

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Use 24-hour clock. Apple doesn't seem to allow YYYY-MM-dd :'(
defaults write com.apple.menuextra.clock DateFormat -string 'EEE MMM d  H:mm'

echo "Creating folder structure..."
[[ ! -d ~/Source ]] && mkdir ~/Source

echo "Configuring Firefox..."
./firefox/set-up-firefox-profile.sh benjamin

echo "Bootstrapping complete"
