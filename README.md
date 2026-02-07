# dotfiles

This is where several of my config files live. I like light modes and simple forgiving setups to accommodate my smooth brain.

## What's in here

```
dotfiles/
├── Brewfile                # Package dependencies (brew bundle)
├── install.sh              # Bootstrap script
├── .gitleaks.toml          # Secret scanning config
├── git/
│   └── .gitconfig          # Git config template
├── wezterm/
│   └── wezterm.lua         # WezTerm terminal (Danqing Light theme)
└── zsh/
    └── .zshrc              # Zsh config (minimal prompt, zoxide)
```

## Quick start

```bash
git clone https://github.com/julian-schn/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script will set up Homebrew (if needed), install packages from the Brewfile, and symlink configs to the right places. It backs up any existing files before overwriting.

After install, fill in your git identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

## Tools

| Tool | What it does |
|------|-------------|
| **WezTerm** | GPU-accelerated terminal with a light color scheme |
| **eza** | Modern `ls` replacement with colors and icons |
| **zoxide** | Smarter `cd` that learns your habits |
| **ripgrep** | Fast `grep` alternative |
| **fd** | Fast `find` alternative |
| **delta** | Pretty git diffs |
| **starship** | Cross-shell prompt (opt-in, see below) |

## Local overrides

Machine-specific tweaks go in local files that are gitignored:

- `zsh/.zshrc.local` — sourced at the end of `.zshrc`
- `wezterm/local.lua` — loaded by the wezterm config

For example, to enable starship and zsh plugins, add to `zsh/.zshrc.local`:

```bash
eval "$(starship init zsh)"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

## Note

This is a macOS setup. Some things might work elsewhere but no promises.
