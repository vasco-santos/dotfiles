# dotfiles

> Set up a macOS machine; @vasco-santos edition 🔧

Terminal environment as code: zsh, iTerm2, git and the handful of CLIs I rely on.
Apple Silicon, macOS 26+.

**This repo is public.** Nothing employer-specific goes in it — see
[Work machines](#work-machines) for where that belongs instead.

## New machine

Run these in order. The first three are prerequisites — the repo can't be cloned
without them.

```sh
# 1. Xcode Command Line Tools — provides git. Opens a GUI dialog; wait for it.
xcode-select --install

# 2. Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# 3. An SSH key, and GitHub told about it
ssh-keygen -t ed25519 -C "santos.vasco10@gmail.com"
brew install gh && gh auth login && gh ssh-key add ~/.ssh/id_ed25519.pub

# 4. Clone and run
git clone git@github.com:vasco-santos/dotfiles.git ~/git/vasco-santos/dotfiles
cd ~/git/vasco-santos/dotfiles
./install.sh

# 5. Quit and reopen iTerm2, then open a fresh shell
exec zsh
```

Steps 2 and 3 are also done by `install.sh` itself, so on a machine where SSH is
already set up you can skip straight to step 4 — clone over HTTPS if you'd rather
not deal with keys first.

`install.sh` is idempotent: re-run it any time. Anything it replaces is moved to
`~/.dotfiles-backup/<timestamp>/` first, and each backup is printed as it happens.
Network failures (plugin clones) warn and continue rather than aborting the run.

On a machine that's already set up, skip the slow package steps:

```sh
SKIP_BREW=1 SKIP_NPM=1 ./install.sh
```

> **Don't move the clone afterwards.** iTerm2 records the preferences folder as an
> absolute path in macOS defaults, so relocating or renaming the directory
> silently stops it loading these settings. If you do move it, re-run
> `scripts/iterm2.sh`.

## What's in here

| Path | Linked to | What it is |
| --- | --- | --- |
| `zsh/zshrc` | `~/.zshrc` | oh-my-zsh, PATH, aliases, tool init |
| `zsh/zprofile` | `~/.zprofile` | login-shell Homebrew setup |
| `git/gitconfig` | `~/.gitconfig` | identity and defaults |
| `git/ignore` | `~/.config/git/ignore` | global gitignore |
| `ssh/config` | `~/.ssh/config` | github.com host config (no keys) |
| `iterm2/` | loaded in place | full iTerm2 preferences |
| `Brewfile` | — | `brew bundle` manifest |
| `scripts/iterm2.sh` | — | points iTerm2 at this repo |
| `scripts/npm-globals.sh` | — | installs the global npm CLIs |

### What it does *not* do

Applications (browsers, Slack, editors, …) are assumed to be installed already —
only iTerm2 is in the `Brewfile`, because it's the one the config depends on.
VS Code settings and extensions are deliberately out of scope; `zsh/zshrc` only
adds the `code` CLI to `PATH` if the app happens to be present.

Not carried over, and not recoverable from here: shell history, SSH private keys,
app licences, and anything in `~/.zshrc.local`.

## iTerm2

The preferences aren't copied — iTerm2 is pointed at `iterm2/` in this repo and
reads from it on launch, writing changes back on quit. Tweak a setting in the
GUI, and it shows up as a diff here ready to commit.

`scripts/iterm2.sh` sets that up. **iTerm2 must be quit first** — a running
instance flushes its own in-memory preferences over the change when it exits, and
the setting is silently lost. The script refuses to run if it detects iTerm2.

Doing it by hand instead: *Settings → General → Preferences → Load preferences
from a custom folder*, point it at `iterm2/`, and set *Save changes* to
**Automatically**.

Included: the **Natural Text Editing** key map, Monaco 12, the dark ANSI palette
and 7% transparency.

Because the plist is rewritten on every quit, `git diff` there will show window
positions and other noise. Skim it before committing — profile names, custom
commands and badge text live in that file too, and this repo is public.

Two settings worth a conscious decision, both currently on: `EnableAPIServer`
(local processes can drive the terminal through iTerm2's Python API, after a
prompt) and `AllowClipboardAccess` (escape sequences in a file you `cat` can
write your clipboard).

### Key bindings that matter

| Keys | Does |
| --- | --- |
| <kbd>⌥</kbd> <kbd>←</kbd> / <kbd>→</kbd> | jump one word |
| <kbd>⌘</kbd> <kbd>←</kbd> / <kbd>→</kbd> | start / end of line |
| <kbd>⌥</kbd> <kbd>⌫</kbd> | delete previous word |
| <kbd>⌘</kbd> <kbd>⌫</kbd> | delete to start of line |
| <kbd>⇧</kbd> / <kbd>⌃</kbd> + arrows | forwarded to the app (tmux, vim, …) |

These come from iTerm2's *Natural Text Editing* preset. To reapply just those on
a profile: *Settings → Profiles → Keys → Key Mappings → Presets → Natural Text
Editing*.

## Shell

zsh + [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh), theme `robbyrussell`, with:

- [alias-tips](https://github.com/djui/alias-tips) — nags you when an alias existed
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) — history-based inline suggestions
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) — colours the command line as you type (must stay last in `plugins`)
- [z](https://github.com/rupa/z) — `z partial-dir-name` jumps to frecent directories
- [thefuck](https://github.com/nvbn/thefuck) — `fuck` fixes the previous command

### Aliases

| Alias | Runs |
| --- | --- |
| `gadd` `gcom` `gst` `gch` `glog` | `git add` / `commit` / `status` / `checkout` / `log` |
| `gpush` `gpull` | `git push` / `git pull` |
| `nrl` `nrt` `nrtn` | `npm run lint` / `test` / `test:node` |
| `npmfi` | wipe `node_modules` + lockfile, reinstall |
| `open-ports` | list listening TCP ports |

## Node

Managed with [`n`](https://github.com/tj/n), prefix `~/.n`. Node itself is **not**
in the `Brewfile` — `brew "n"` installs only the version manager, and `install.sh`
then runs `n lts` to get a runtime. Until you open a new shell, `node` won't be on
your `PATH`.

`scripts/npm-globals.sh` installs these globally, and re-running it upgrades them:

- `@github/copilot`
- `@google/gemini-cli`
- `@openai/codex`

## Work machines

The tracked files carry the personal identity. Employer-specific config goes in
these untracked files, all of which are optional and ignored when absent:

| File | For |
| --- | --- |
| `~/.gitconfig-work` | work name/email; auto-applied to any repo under `~/work/` |
| `~/.gitconfig.local` | other machine-specific git config |
| `~/.ssh/config.local` | internal hosts, bastions, jumphosts |
| `~/.zshrc.local` | tokens, one-off `PATH` entries; sourced last |
| `~/.zprofile.local` | login-shell equivalent |

Example `~/.gitconfig-work`:

```ini
[user]
	email = vasco@employer.example
```

## Day-to-day

The dotfiles are symlinks, so editing `~/.zshrc` edits `zsh/zshrc` in this repo.

```sh
cd ~/git/vasco-santos/dotfiles
git status                     # includes any iTerm2 tweaks made in the GUI
git add -p && git commit && git push
```

On the other machine: `git pull && exec zsh` (restart iTerm2 if the plist changed).

Regenerate the `Brewfile` after installing something worth keeping:

```sh
brew bundle dump --force --file=Brewfile
```

### Rolling back

Every file `install.sh` replaced is in `~/.dotfiles-backup/<timestamp>/`, mirroring
its original layout. To undo: `rm` the symlink and `mv` the backup into place.

## Credits

- @mathiasbynens — https://github.com/mathiasbynens/dotfiles
- @daviddias — https://github.com/daviddias/dotfiles
- olizilla — https://github.com/olizilla/dotfiles
