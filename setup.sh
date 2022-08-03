#!/bin/sh
cd $(dirname "$0")

macos() {
    if ! which brew > /dev/null; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew install \
        coreutils findutils binutils inetutils tmux xz gnu-tar gnupg2 wget jq \
        git mercurial subversion python ruby node npm yarn nmap tig \
        htop pstree llvm qemu autoconf autogen automake cmake watch sloc \
        ripgrep fd
    brew install --cask \
        shiftit keepingyouawake google-chrome firefox visual-studio-code \
        wireshark vlc java xquartz mactex-no-gui adobe-acrobat-reader skim

    defaults write NSGlobalDomain AppleShowScrollBars -string WhenScrolling
    # Expand the save dialog by default.
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
    # Save a file on the local machine instead of iCloud by default.
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
    # Disable “Are you sure you want to open this application?”
    defaults write com.apple.LaunchServices LSQuarantine -bool false
    # Disable Crash Repoter
    defaults write com.apple.CrashReporter DialogType -string none
    # Disable spelling correction
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    # Wipe out persistent Dock icons
    defaults write com.apple.dock persistent-apps -array []
    defaults write com.apple.dock show-recents -int 0
    # Faster key repeat.
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 10

    killall Finder && killall Dock
}

linux() {
    SUDO=sudo
    if [ "$(whoami)" = "root" ]; then
        SUDO=
    fi

    $SUDO apt-get update
    $SUDO apt-get install -qy \
        coreutils build-essential python3 python3-pip \
        sudo tmux curl wget tree git watch zsh nodejs npm
}

main() {
    echo "Installing packages..."
    if [ "$(uname)" = "Darwin" ]; then
        macos
    fi
    
    if [ "$(uname)" = "Linux" ]; then
        linux
    fi
    
    echo "Linking config files..."
    set +e
    mkdir -p ~/.ssh
    ln -s gitconfig   ~/.gitconfig
    ln -s tmux.conf   ~/.tmux.conf
    ln -s zshrc       ~/.zshrc
    ln -s ssh_config  ~/.ssh/config

    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env

    echo "Installing zsh plugins..."
    if [[ -d ~/.zsh/zsh-syntax-highlighting ]]; then
        pushd ~/.zsh/zsh-syntax-highlighting; git pull; popd
    else
        git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
    fi

    if [[ -d ~/.zsh/dircolors-solarized ]]; then
        pushd ~/.zsh/dircolors-solarized; git pull; popd
    else
        git clone https://github.com/seebi/dircolors-solarized.git ~/.zsh/dircolors-solarized
    fi

    if [[ -d ~/.zsh/zsh-completions ]]; then
        pushd ~/.zsh/zsh-completions; git pull; popd
    else
        git clone https://github.com/zsh-users/zsh-completions ~/.zsh/zsh-completions
    fi

    echo "Done!"
}

main