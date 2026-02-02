# ---- Zsh basics ----
setopt PROMPT_SUBST
PROMPT='%F{8}%~%f %(?..%F{1}[%?]%f )%# '

# ---- History (minimal & sane) ----
HISTFILE="$HOME/.zhistory"
HISTSIZE=5000
SAVEHIST=5000
setopt SHARE_HISTORY

# ---- zoxide (smart cd, optional) ----
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# ---- the one command im taking with me from the windows cmd ----
alias cls=clear

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

true
