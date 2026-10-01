#!/usr/bin/env bash
# Dock: small, hidden, on the left, no recents. Rerunnable.
set -euo pipefail

[[ "$(uname)" == "Darwin" ]] || { echo "dock.sh: macOS only" >&2; exit 1; }

# ── Look ────────────────────────────────────────────
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock largesize -int 16
defaults write com.apple.dock mineffect -string scale

# ── Autohide with no delay and no slide animation ───
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

# ── No recent apps section ──────────────────────────
defaults write com.apple.dock show-recents -bool false

killall Dock
