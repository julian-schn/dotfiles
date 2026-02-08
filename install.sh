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
echo "  2. Optional — add to zsh/.zshrc.local:"
echo "     eval \"\$(starship init zsh)\""
echo "     source \$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
echo "     source \$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
echo ""
echo "  3. Restart your terminal: exec zsh"
