# dotfiles

> Set up a macOS machine; @vasco-santos edition 🔧

## Terminal and Shell

Install iterm (iterm2 v3) and a shell (zsh). Download and install https://www.iterm2.com, followed by:

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## Brewing time

```sh
# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Run repo custom brew script
./brew.sh
```
