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
        local backup
        backup="${dst}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$dst" "$backup"
        info "Backed up $dst → $backup"
    fi

    # -n is load-bearing for directory links. Without it, a rerun sees $dst as an
    # existing symlink-to-directory, follows it, and creates the link *inside* the
    # target — producing nvim/nvim, wezterm/wezterm, and so on with each run.
    ln -sfn "$src" "$dst"
    success "Linked $dst → $src"
}

# ── Create symlinks ────────────────────────────────
info "Symlinking configs..."
link "$DOTFILES_DIR/wezterm"        "$HOME/.config/wezterm"
link "$DOTFILES_DIR/nvim"           "$HOME/.config/nvim"
link "$DOTFILES_DIR/yazi"           "$HOME/.config/yazi"
link "$DOTFILES_DIR/zsh/.zshrc"     "$HOME/.zshrc"
# .zshrc sources ~/.zsh_aliases — without this link the aliases and
# functions (pc, scuts, mkcd, h) silently never load.
link "$DOTFILES_DIR/zsh/aliases.zsh" "$HOME/.zsh_aliases"
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# ── Claude Code ────────────────────────────────────
# File-level links wherever the parent directory also holds runtime state:
# ~/.claude has sessions/ and history.jsonl, ~/.claude/hooks has hooks/state/.
# rules/ is ours alone, so the whole directory is linked and new rules need no reinstall.
# skills/ is linked one level down so other skills can still be installed alongside.
link "$DOTFILES_DIR/claude/CLAUDE.md"                    "$HOME/.claude/CLAUDE.md"
link "$DOTFILES_DIR/claude/settings.json"                "$HOME/.claude/settings.json"
link "$DOTFILES_DIR/claude/rules"                        "$HOME/.claude/rules"
link "$DOTFILES_DIR/claude/skills/ui-review"             "$HOME/.claude/skills/ui-review"
link "$DOTFILES_DIR/claude/hooks/check-docs-stale.sh"    "$HOME/.claude/hooks/check-docs-stale.sh"
link "$DOTFILES_DIR/claude/hooks/conventional-commit.sh" "$HOME/.claude/hooks/conventional-commit.sh"

# Playwright MCP is registered through the CLI, not symlinked: user-scope MCP servers
# live in ~/.claude.json alongside per-project local history, which must stay untracked.
if command -v claude &>/dev/null; then
    if claude mcp get playwright &>/dev/null; then
        success "playwright MCP already registered"
    else
        info "Registering playwright MCP (user scope)..."
        claude mcp add --scope user playwright -- npx -y @playwright/mcp@latest
        success "playwright MCP registered"
    fi
else
    info "claude CLI not found — skipping playwright MCP"
fi

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
