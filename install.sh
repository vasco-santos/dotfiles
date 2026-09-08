#!/usr/bin/env bash
#
# Bootstrap a macOS machine from this repo.
# Safe to re-run: every step is idempotent and existing files are backed up.
#
#   ./install.sh
#
# Steps can be skipped when re-running on a machine that's already set up:
#
#   SKIP_BREW=1 SKIP_NPM=1 ./install.sh
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

info() { printf '\033[0;34m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[0;33m!!\033[0m  %s\n' "$1" >&2; }
skip() { [ "${1:-0}" != 0 ] && [ -n "${1:-}" ]; }

# link <source-in-repo> <target-in-home>
link() {
  local src="$DOTFILES/$1" dst="$2" rel
  rel="${dst#"$HOME"/}"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "    ok    $dst"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP/$(dirname "$rel")"
    mv "$dst" "$BACKUP/$rel"
    warn "backed up existing $dst -> $BACKUP/$rel"
  fi
  ln -s "$src" "$dst"
  echo "    link  $dst"
}

# clone_or_pull <repo-url> <destination>
# Never fatal: a network blip must not stop the run before the symlink step.
clone_or_pull() {
  local repo="$1" dest="$2" name
  name="$(basename "$dest")"
  if [ -d "$dest/.git" ]; then
    if git -C "$dest" pull --quiet --ff-only 2>/dev/null; then
      echo "    pulled $name"
    else
      warn "could not fast-forward $name — leaving it as-is"
    fi
  elif [ -e "$dest" ]; then
    warn "$dest exists but is not a git checkout — skipping"
  elif git clone --quiet --depth 1 "$repo" "$dest"; then
    echo "    cloned $name"
  else
    warn "could not clone $name from $repo"
  fi
}

# ---------------------------------------------------------------------------
if skip "${SKIP_BREW:-}"; then
  info "Homebrew (skipped)"
else
  info "Homebrew"
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # curl-pipe-to-shell exits 0 even when the download fails, so verify.
    [ -x /opt/homebrew/bin/brew ] || { warn "Homebrew install failed"; exit 1; }
  fi
fi

# Needed by every later step, so it runs even when the install itself is skipped.
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

skip "${SKIP_BREW:-}" || brew bundle --file="$DOTFILES/Brewfile"

# ---------------------------------------------------------------------------
info "oh-my-zsh"
if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # Verify: without this, ~/.zshrc sources a file that doesn't exist and every
  # new shell breaks.
  [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ] || { warn "oh-my-zsh install failed"; exit 1; }
fi

info "zsh plugins"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
clone_or_pull https://github.com/djui/alias-tips.git                     "$ZSH_CUSTOM/plugins/alias-tips"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions.git       "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git   "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

info "z jumper"
clone_or_pull https://github.com/rupa/z.git "$HOME/.z-jump"

# ---------------------------------------------------------------------------
info "Symlinks"
link zsh/zshrc     "$HOME/.zshrc"
link zsh/zprofile  "$HOME/.zprofile"
link git/gitconfig "$HOME/.gitconfig"
link git/ignore    "$HOME/.config/git/ignore"
link ssh/config    "$HOME/.ssh/config"
chmod 700 "$HOME/.ssh"

# ---------------------------------------------------------------------------
if skip "${SKIP_NPM:-}"; then
  info "Node (skipped)"
else
  info "Node"
  # `brew "n"` installs the version manager only — there is no node yet.
  if [ ! -x "$HOME/.n/bin/node" ] && command -v n >/dev/null; then
    N_PREFIX="$HOME/.n" n lts
  fi
  # n installs into ~/.n/bin, which zsh/zshrc only adds for *future* shells.
  # This bash process needs it now, or npm-globals.sh can't find npm.
  export N_PREFIX="$HOME/.n"
  export PATH="$N_PREFIX/bin:$PATH"
  "$DOTFILES/scripts/npm-globals.sh" || warn "npm globals failed — rerun scripts/npm-globals.sh"
fi

# ---------------------------------------------------------------------------
info "iTerm2"
"$DOTFILES/scripts/iterm2.sh" || warn "iTerm2 setup skipped; quit iTerm2 and run scripts/iterm2.sh"

# ---------------------------------------------------------------------------
info "Done"
[ -d "$BACKUP" ] && warn "Replaced files were backed up to $BACKUP"
cat <<'NEXT'

Remaining manual steps:
  1. Restart iTerm2 so it picks up the preferences from this repo.
  2. Open a new shell:  exec zsh
  3. Work machine? Put the work git identity in ~/.gitconfig-work (applies to
     ~/work/), internal SSH hosts in ~/.ssh/config.local. Both untracked.

NEXT
