# dotfiles

> Set up a macOS machine; @vasco-santos edition 🔧

Terminal environment as code: zsh, iTerm2, git and the handful of CLIs I rely on.

## New machine

```sh
git clone git@github.com:vasco-santos/dotfiles.git ~/git/vasco-santos/dotfiles
cd ~/git/vasco-santos/dotfiles
./install.sh
```

`install.sh` is idempotent — re-run it any time. Anything it replaces is moved to
`~/.dotfiles-backup/<timestamp>/` first.

On a machine that's already set up, skip the slow package steps:

```sh
SKIP_BREW=1 SKIP_NPM=1 ./install.sh
```

If you cloned over HTTPS because SSH isn't set up yet, do that part first:

```sh
ssh-keygen -t ed25519 -C "santos.vasco10@gmail.com"
brew install gh && gh auth login && gh ssh-key add ~/.ssh/id_ed25519.pub
```

## What's in here

| Path | Linked to | What it is |
| --- | --- | --- |
| `zsh/zshrc` | `~/.zshrc` | oh-my-zsh, PATH, aliases, tool init |
| `zsh/zprofile` | `~/.zprofile` | login-shell Homebrew setup |
| `git/gitconfig` | `~/.gitconfig` | identity and sane defaults |
| `git/ignore` | `~/.config/git/ignore` | global gitignore |
| `ssh/config` | `~/.ssh/config` | github.com host config (no keys) |
| `iterm2/` | loaded in place | full iTerm2 preferences |
| `Brewfile` | — | `brew bundle` manifest |
| `scripts/` | — | iTerm2 + npm globals setup |

## iTerm2

The preferences aren't copied — iTerm2 is pointed at `iterm2/` in this repo and
reads from it on launch, writing changes back on quit. Tweak a setting in the
GUI, and it shows up as a diff here ready to commit.

`scripts/iterm2.sh` sets that up (it needs iTerm2 **closed** to run). Doing it by
hand instead: *Preferences → General → Preferences → Load preferences from a
custom folder*, point it at `iterm2/`, and set *Save changes* to **Automatically**.

Included: the **Natural Text Editing** key map, Monaco 12, the dark ANSI palette
and 7% transparency.

### Key bindings that matter

| Keys | Does |
| --- | --- |
| <kbd>⌥</kbd> <kbd>←</kbd> / <kbd>→</kbd> | jump one word |
| <kbd>⌘</kbd> <kbd>←</kbd> / <kbd>→</kbd> | start / end of line |
| <kbd>⌥</kbd> <kbd>⌫</kbd> | delete previous word |
| <kbd>⌘</kbd> <kbd>⌫</kbd> | delete to start of line |
| <kbd>⇧</kbd> / <kbd>⌃</kbd> + arrows | forwarded to the app (tmux, vim, …) |

These come from iTerm2's *Natural Text Editing* preset. To reapply just those on
a profile: *Preferences → Profiles → Keys → Key Mappings → Presets → Natural Text
Editing*.

## Shell

zsh + [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh), theme `robbyrussell`, with:

- [alias-tips](https://github.com/djui/alias-tips) — nags you when an alias existed
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) — history-based inline suggestions
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) — colours the command line as you type
- [z](https://github.com/rupa/z) — `z partial-dir-name` jumps to frecent directories
- [thefuck](https://github.com/nvbn/thefuck) — `fuck` fixes the previous command

Node is managed with [`n`](https://github.com/tj/n) (`N_PREFIX=~/.n`), not nvm.

Machine-specific bits — work tokens, one-off PATH entries — go in `~/.zshrc.local`,
which is sourced last and never tracked here.

## Credits

- @mathiasbynens — https://github.com/mathiasbynens/dotfiles
- @daviddias — https://github.com/daviddias/dotfiles
- olizilla — https://github.com/olizilla/dotfiles
