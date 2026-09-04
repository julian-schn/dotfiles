# dotfiles

This is where several of my config files live. I like light modes and simple forgiving setups to accommodate my smooth brain.

## What's in here

```
dotfiles/
├── Brewfile                # Package dependencies (brew bundle)
├── install.sh              # Bootstrap script
├── .gitleaks.toml          # Secret scanning config
├── claude/                 # Claude Code config (see below)
│   ├── CLAUDE.md           # Global instructions
│   ├── settings.json       # Model, theme, plugins, hooks
│   ├── rules/              # Path-scoped rules
│   ├── skills/             # On-demand procedures
│   └── hooks/              # Shell hooks
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
| `slog` | `git log --oneline` — compact commit history |
| `sweeper` | Play terminal Minesweeper |

## Tools

| Tool | What it does |
|------|-------------|
| **Neovim** | Text editor with treesitter, telescope, and everforest light theme |
| **WezTerm** | GPU-accelerated terminal with a light color scheme |
| **tmux** | Terminal multiplexer — detached sessions that survive closing the terminal; `scuts` lists the basics |
| **eza** | Modern `ls` replacement with colors and icons |
| **zoxide** | Smarter `cd` that learns your habits |
| **ripgrep** | Fast `grep` alternative |
| **fd** | Fast `find` alternative |
| **delta** | Pretty git diffs |
| **sweeper** | Terminal Minesweeper ([tui-sweeper](https://github.com/julian-schn/tui-sweeper)) — not from Homebrew; `install.sh` builds it with `go install`, so it needs Go and lands in `$(go env GOPATH)/bin` |

## Claude Code

`~/.claude/` mixes portable config with machine-local state, so only the config half is
tracked here and `install.sh` symlinks it back into place.

| Tracked | Links to | What it does |
|---------|----------|--------------|
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Commit conventions, running detached work in tmux, and when to push back on me |
| `claude/settings.json` | `~/.claude/settings.json` | Model, light theme, fullscreen TUI, plugins, hooks |
| `claude/rules/` | `~/.claude/rules/` | Rules scoped to file globs — load only when Claude reads a matching file |
| `claude/skills/ui-review/` | `~/.claude/skills/ui-review/` | Accessibility and responsive audit, pulled in on UI work |
| `claude/hooks/*.sh` | `~/.claude/hooks/` | See below |

Two hooks:

- **`conventional-commit.sh`** — a `PreToolUse` hook on `git commit*`. It reads the
  message off the command line and exits 2 if the subject isn't
  `type(scope): subject`, which blocks the commit and hands the reason back to Claude to
  retry. It checks structure and trailing periods only; lowercase and imperative mood are
  guidance in `CLAUDE.md`, not enforced, because `fix: JSON parser crash` is fine.
  Its `if: "Bash(git commit*)"` filter matches any command *containing* `git commit`, so
  a shell one-liner that merely quotes a commit message will trip it too.
- **`check-docs-stale.sh`** — a `Stop` hook. If the newest commit touching code is newer
  than the newest commit touching Markdown, it nudges once per `HEAD` to review the docs.

Playwright MCP is registered by `install.sh` with `claude mcp add --scope user` rather
than symlinked, because user-scope MCP servers live in `~/.claude.json` next to per-project
local history that must stay out of git.

Everything else under `~/.claude/` is state and is deliberately untracked: `sessions/`,
`projects/` (including auto-memory), `history.jsonl`, `hooks/state/`, `plugins/`,
`backups/`, `telemetry/`. Plugin marketplaces are declared in `settings.json`, so plugins
re-resolve on a fresh machine without copying their cache.

Because `settings.json` is a symlink, changes Claude Code makes itself — toggling the
theme, enabling a plugin, running `/doctor` — show up as edits in this repo. That is the
point, but it does mean `git status` goes dirty when you change a setting.

Per-repo permission allowlists belong in that repo's `.claude/settings.local.json`, which
is gitignored.

## Local overrides

Machine-specific tweaks go in local files that are gitignored:

- `zsh/.zshrc.local` — sourced at the end of `.zshrc`
- `wezterm/local.lua` — loaded by the wezterm config; return either a table of
  config keys to merge, or a function that takes `config` and mutates it

Put host-only settings here rather than editing the tracked configs — that is
what keeps installer-appended `PATH` lines out of version control.

## Note

This is a macOS setup. Some things might work elsewhere but no promises.
