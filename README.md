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
├── nvim/
│   └── init.lua            # Neovim config (everforest light, telescope, treesitter)
├── wezterm/
│   └── wezterm.lua         # WezTerm terminal (Danqing Light theme)
└── zsh/
    ├── .zshrc              # Zsh config (minimal prompt, zoxide, PATH)
    └── aliases.zsh         # Aliases & functions (symlinked to ~/.zsh_aliases)
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

## Aliases & commands

Defined in `zsh/aliases.zsh`. Forgot one? Run `scuts` — it prints this list (plus the WezTerm
keybindings) in any shell.

| Command | What it does |
|---------|-------------|
| `cls` | Clear the screen |
| `home` | `cd` to home |
| `h <dir>` | `cd` to `~/<dir>` |
| `mkcd <dir>` | Create a directory and `cd` into it |
| `pc` | Copy the current path to the clipboard (no trailing newline) |
| `scuts` | Show the shortcut cheat sheet |
| `sweeper` | Play terminal Minesweeper |

## Tools

| Tool | What it does |
|------|-------------|
| **Neovim** | Text editor with treesitter, telescope, and everforest light theme |
| **WezTerm** | GPU-accelerated terminal with a light color scheme |
| **eza** | Modern `ls` replacement with colors and icons |
| **zoxide** | Smarter `cd` that learns your habits |
| **ripgrep** | Fast `grep` alternative |
| **fd** | Fast `find` alternative |
| **delta** | Pretty git diffs |
| **sweeper** | Terminal Minesweeper ([tui-sweeper](https://github.com/julian-schn/tui-sweeper)) — not from Homebrew; `install.sh` builds it with `go install`, so it needs Go and lands in `$(go env GOPATH)/bin` |

## Local overrides

Machine-specific tweaks go in local files that are gitignored:

- `zsh/.zshrc.local` — sourced at the end of `.zshrc`
- `wezterm/local.lua` — loaded by the wezterm config; return either a table of
  config keys to merge, or a function that takes `config` and mutates it

Put host-only settings here rather than editing the tracked configs — that is
what keeps installer-appended `PATH` lines out of version control.

## Note

This is a macOS setup. Some things might work elsewhere but no promises.
