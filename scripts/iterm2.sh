#!/usr/bin/env bash
#
# Point iTerm2 at the preferences stored in this repo.
#
# iTerm2 then reads com.googlecode.iterm2.plist from ./iterm2 on launch and
# writes changes back there on quit — so tweaking a setting in the GUI shows
# up as a diff in this repo, ready to commit.
#
# This brings across, in one shot:
#   - the Natural Text Editing key map (61 bindings), including
#       Option + <- / ->   jump by word        (sends ESC b / ESC f)
#       Cmd    + <- / ->   start / end of line (sends ^A / ^E)
#       Option + Delete    delete word back
#       Cmd    + Delete    delete to line start
#   - font (Monaco 12), the dark ANSI palette, 7% transparency
#   - terminal type, bell and cursor settings
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PREFS_DIR="$DOTFILES/iterm2"

if [ ! -f "$PREFS_DIR/com.googlecode.iterm2.plist" ]; then
  echo "No plist found in $PREFS_DIR" >&2
  exit 1
fi

# pgrep cannot see iTerm2 on macOS 26 (verified: `pgrep -x iTerm2` returns 1
# while it is running), so ask the app itself, falling back to the full ps path.
iterm_running() {
  if command -v osascript >/dev/null &&
     [ "$(osascript -e 'application "iTerm" is running' 2>/dev/null)" = "true" ]; then
    return 0
  fi
  ps -A -o comm= | grep -q '/iTerm\.app/Contents/MacOS/iTerm2$'
}

if iterm_running; then
  echo "iTerm2 is running — quit it first, or it overwrites these settings on exit." >&2
  exit 1
fi

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$PREFS_DIR"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# Save changes back to the folder automatically instead of prompting on quit.
# 0 = always save, 1 = never save, 2 = ask each time.
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 0
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true

echo "iTerm2 will load preferences from $PREFS_DIR on next launch."
