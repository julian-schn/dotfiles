# ---- Aliases ----
alias cls=clear
alias home='cd ~'
alias pc='printf "%s" "$PWD" | pbcopy && echo "copied: $PWD"'

alias scuts='echo "
WEZTERM SHORTCUTS (macOS)

PANES
  ⌘ D            Vertical split
  ⌘ ⇧ D          Horizontal split
  ⌘ ⌥ ← ↑ ↓ →    Move between panes
  ⌘ W            Close pane

TABS
  ⌘ T            New tab
  ⌘ W            Close tab
  ⌘ ⇧ ]          Next tab
  ⌘ ⇧ [          Previous tab
  ⌘ 1–9          Go to tab

SHELL
  cls            Clear the screen
  home           cd to home
  h <dir>        cd to ~/<dir>
  mkcd <dir>     Create a directory and cd into it
  pc             Copy the current path to the clipboard
  scuts          Show this cheat sheet

TOOLS
  sweeper        Terminal Minesweeper
"'

# ---- Functions ----
h() { cd "$HOME/${1:-}"; }
mkcd() { mkdir -p "$1" && cd "$1"; }
