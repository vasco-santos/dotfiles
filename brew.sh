#!/usr/bin/env bash

# Use latest brew
brew update
brew upgrade

# install command-line tools using homebrew.

# save homebrew’s installed path.
BREW_PREFIX=$(brew --prefix)

# install GNU core utilities (those that come with macOS are outdated).
# add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# install GNU `find`, `locate`, `updatedb`, and `xargs`
brew install findutils

# install `wget` with IRI support.
brew install wget --with-iri

# install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen
brew install rename
brew install ssh-copy-id

# install all the dev things
brew install git 
brew install diff-so-fancy
brew install wget
brew install watch watchman
brew install tree
brew install node
brew install ipfs
brew cask install gpg-suite
brew cask install ag
brew cask install docker
brew cask install visual-studio-code

# install all the useful apps
brew cask install 1password
brew cask install google-chrome
brew cask install slack
brew cask install spotify
brew cask install vlc
brew cask install zoomus
brew cask install dropbox

# remove outdated versions
brew cleanup
