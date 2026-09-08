#!/usr/bin/env bash
#
# Globally installed CLIs that don't come from Homebrew.
#
set -euo pipefail

command -v npm >/dev/null || { echo "npm not found — install Node first." >&2; exit 1; }

npm install -g \
  @github/copilot \
  @google/gemini-cli \
  @openai/codex

echo "Installed. Current globals:"
npm ls -g --depth=0
