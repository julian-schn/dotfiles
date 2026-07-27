#!/usr/bin/env bash
set -euo pipefail

# ── Colors ──────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { printf "${YELLOW}→${NC} %s\n" "$1"; }
success() { printf "${GREEN}✓${NC} %s\n" "$1"; }
error()   { printf "${RED}✗${NC} %s\n" "$1" >&2; exit 1; }

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── macOS only ──────────────────────────────────────
[[ "$(uname)" == "Darwin" ]] || error "This script only works on macOS"

info "Starting dotfiles setup..."

# ── Homebrew ────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    success "Homebrew installed"
else
    success "Homebrew already installed"
fi

info "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"
success "Packages installed"

# ── Go tools ────────────────────────────────────────
# sweeper declares "module sweeper" so it has no remote import path —
# clone it and install from the working tree.
if command -v go &>/dev/null; then
    info "Installing sweeper..."
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    git clone --depth 1 https://github.com/julian-schn/tui-sweeper.git "$tmp/tui-sweeper"
    (cd "$tmp/tui-sweeper" && go install .)
    success "sweeper installed to $(go env GOPATH)/bin"
else
    info "Go not found — skipping sweeper (install Go, then rerun)"
fi

# ── Symlink helper ──────────────────────────────────
# Creates a symlink, backing up existing files if needed
link() {
    local src="$1" dst="$2"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dst")"

    # Back up existing non-symlink targets
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        local backup="${dst}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$dst" "$backup"
        info "Backed up $dst → $backup"
    fi

    ln -sf "$src" "$dst"
    success "Linked $dst → $src"
}

# ── Create symlinks ────────────────────────────────
info "Symlinking configs..."
link "$DOTFILES_DIR/wezterm"        "$HOME/.config/wezterm"
link "$DOTFILES_DIR/nvim"           "$HOME/.config/nvim"
link "$DOTFILES_DIR/zsh/.zshrc"     "$HOME/.zshrc"
# .zshrc sources ~/.zsh_aliases — without this link the aliases and
# functions (pc, scuts, mkcd, h) silently never load.
link "$DOTFILES_DIR/zsh/aliases.zsh" "$HOME/.zsh_aliases"
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# ── Done ────────────────────────────────────────────
echo ""
success "Dotfiles installed!"
echo ""
info "Next steps:"
echo "  1. Fill in your git identity:"
echo "     git config --global user.name \"Your Name\""
echo "     git config --global user.email \"you@example.com\""
echo ""
echo "  2. Restart your terminal: exec zsh"
