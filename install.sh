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

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

info() { printf '\033[0;34m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[0;33m!!\033[0m  %s\n' "$1"; }

# link <source-in-repo> <target-in-home>
link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "    ok    $dst"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP/$(dirname "${dst#$HOME/}")"
    mv "$dst" "$BACKUP/${dst#$HOME/}"
    echo "    moved $dst -> $BACKUP/${dst#$HOME/}"
  fi
  ln -s "$src" "$dst"
  echo "    link  $dst"
}

# ---------------------------------------------------------------------------
if [ -n "${SKIP_BREW:-}" ]; then
  info "Homebrew (skipped)"
else
  info "Homebrew"
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew bundle --file="$DOTFILES/Brewfile"
fi

# ---------------------------------------------------------------------------
info "oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

info "zsh plugins"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
clone_or_pull() {
  local repo="$1" dest="$2"
  if [ -d "$dest/.git" ]; then
    git -C "$dest" pull --quiet --ff-only && echo "    pulled $(basename "$dest")"
  else
    git clone --quiet --depth 1 "$repo" "$dest" && echo "    cloned $(basename "$dest")"
  fi
}
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
if [ -n "${SKIP_NPM:-}" ]; then
  info "Node (skipped)"
else
  info "Node"
  if command -v n >/dev/null && [ ! -x "$HOME/.n/bin/node" ]; then
    N_PREFIX="$HOME/.n" n lts
  fi
  "$DOTFILES/scripts/npm-globals.sh"
fi

# ---------------------------------------------------------------------------
info "iTerm2"
# Skipped rather than fatal when iTerm2 is open — rerun scripts/iterm2.sh later.
"$DOTFILES/scripts/iterm2.sh" || warn "iTerm2 setup skipped; quit iTerm2 and run scripts/iterm2.sh"

# ---------------------------------------------------------------------------
info "Done"
[ -d "$BACKUP" ] && warn "Replaced files were backed up to $BACKUP"
cat <<'NEXT'

Remaining manual steps:
  1. Generate/copy an SSH key:  ssh-keygen -t ed25519 -C "santos.vasco10@gmail.com"
     then:                      gh auth login && gh ssh-key add ~/.ssh/id_ed25519.pub
  2. Restart iTerm2 so it picks up the preferences from this repo.
  3. Open a new shell:          exec zsh

NEXT
