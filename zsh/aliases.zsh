# ---- Aliases ----
alias cls=clear
alias home='cd ~'

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
"'

# ---- Functions ----
h() { cd "$HOME/${1:-}"; }
mkcd() { mkdir -p "$1" && cd "$1"; }
