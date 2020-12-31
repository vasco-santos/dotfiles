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

## z jumper

Clone [z jumper](https://github.com/rupa/z) into your user folder.

## Configuration

### zsh

- Install [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh#basic-installation)
- rm ~/.zshrc
- ln zshrc ~/.zshrc

Install plugins:

#### alias-tips

[Follow repo instructions](https://github.com/djui/alias-tips#oh-my-zsh)

#### zsh-autosuggestions

[Follow repo instructions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)

#### zsh-syntax-highlighting

[Follow repo instructions](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh)
