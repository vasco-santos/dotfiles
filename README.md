# dotfiles

> Set up a macOS machine; @vasco-santos edition 🔧

## Terminal 

Install iterm (iterm2 v3) https://www.iterm2.com and configure its profile keys to use preset `Natural Text Editing` (iTerm preferences, profiles, keys, load preset).

## Shell

Install shell (zsh).

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

Clone [z jumper](https://github.com/rupa/z) into your user folder under `.z-jump`.

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

## Credits

- @mathiasbynens -- https://github.com/mathiasbynens/dotfiles
- @daviddias -- https://github.com/daviddias/dotfiles
- olizilla -- https://github.com/olizilla/dotfiles
