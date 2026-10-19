# Brewfile — macOS development environment
# Install with: brew bundle

# ── Modern CLI Tools ────────────────────────────────
brew "eza"
brew "zoxide"
brew "ripgrep"
brew "fd"
brew "git-delta"
# Fuzzy finder; .zshrc points it at fd and binds ⌃R / ⌃T / ⌥C.
brew "fzf"
# macOS ships jq, but the conventional-commit hook depends on it — be explicit.
brew "jq"

# ── Shell tooling ───────────────────────────────────
# Lints install.sh and the Claude hooks.
brew "shellcheck"

# ── Terminal multiplexer ────────────────────────────
# Keeps detached processes (dev servers, long builds) alive across sessions.
brew "tmux"

# ── File manager ────────────────────────────────────
# poppler and sevenzip give yazi PDF and archive previews.
brew "yazi"
brew "poppler"
brew "sevenzip"

# ── Documents ───────────────────────────────────────
# pandoc converts markdown; typst is its PDF engine (no LaTeX needed). See md2pdf.
brew "pandoc"
brew "typst"

# ── Editor ─────────────────────────────────────────
brew "neovim"

# ── Applications ────────────────────────────────────
cask "wezterm"

# ── Fonts ───────────────────────────────────────────
cask "font-jetbrains-mono-nerd-font"
