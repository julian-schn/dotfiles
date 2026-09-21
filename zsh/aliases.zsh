# ---- Aliases ----
alias cls=clear
alias home='cd ~'
alias pc='printf "%s" "$PWD" | pbcopy && echo "copied: $PWD"'
alias slog='git log --oneline'

# ---- Cheat sheets ----
# scuts: key shortcuts inside WezTerm and tmux. qhelp: commands you type, plus yazi basics.
scuts() {
  cat <<'EOF'

WEZTERM
  ⌘ D            Vertical split
  ⌘ ⇧ D          Horizontal split
  ⌘ ⌥ ← ↑ ↓ →    Move between panes
  ⌘ W            Close pane / tab
  ⌘ T            New tab
  ⌘ ⇧ ] / ⌘ ⇧ [  Next / previous tab
  ⌘ 1–9          Go to tab

TMUX (prefix = ⌃B, press then release)
  ⌃B D           Detach (leaves it running)
  ⌃B %  /  ⌃B "  Split left-right / top-bottom
  ⌃B ←↑↓→        Move between panes
  ⌃B C  /  ⌃B N  New window / next window
  ⌃B [           Scroll back (Q to exit)

Commands: qhelp
EOF
}

qhelp() {
  cat <<'EOF'

SHELL
  cls            Clear the screen
  home           cd to home
  h <dir>        cd to ~/<dir>
  mkcd <dir>     Create a directory and cd into it
  pc             Copy the current path to the clipboard

TOOLS
  y              Open yazi (file manager)
  slog           Compact one-line git log
  sweeper        Terminal Minesweeper

YAZI (inside y)
  ← →  /  ⏎      Parent folder / enter, open
  space          Select; then y copy, x cut, p paste, d trash
  a  /  r        Create (end with / for a folder) / rename
  s  /  S  /  Z  Search names / contents / jump with zoxide
  q  /  ~        Quit and cd there / full key list

TMUX
  tmux new -s <name>        New named session
  tmux new -d -s <n> <cmd>  Run <cmd> detached
  tmux ls                   List sessions
  tmux a -t <name>          Attach to one

POWER
  blank <pid>    Screen off, Mac keeps running until that process exits
  blank          Same, but held until you run unblank
  unblank        Let the Mac sleep normally again

Key shortcuts: scuts
EOF
}

# ---- Functions ----
h() { cd "$HOME/${1:-}"; }
mkcd() { mkdir -p "$1" && cd "$1"; }

# Yazi wrapper from its docs: cd into the directory yazi was in when you quit.
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Keep the Mac working with the screen off. KeepingYouAwake uses `caffeinate -d`,
# which pins the display on; `-i` alone blocks only idle *system* sleep, so the
# display still sleeps.
#   blank <pid>   release when that process exits
#   blank         hold until 'unblank'; caffeinate has no expiry of its own
_blank_pidfile() { print -r -- "${TMPDIR:-/tmp}/blank-caffeinate.pid"; }

# Only ever signal a pid that is still a caffeinate: a stale pidfile could
# otherwise name a recycled pid belonging to something else entirely.
_blank_running() {
  local pidfile=$(_blank_pidfile) pid
  [[ -f $pidfile ]] || return 1
  pid=$(<"$pidfile") || return 1
  [[ $pid == <-> ]] || return 1
  [[ $(ps -p "$pid" -o comm= 2>/dev/null) == *caffeinate* ]] || return 1
  print -r -- "$pid"
}

blank() {
  local previous
  previous=$(_blank_running) && kill "$previous" 2>/dev/null
  # Validate before quitting KeepingYouAwake, so a typo cannot leave the Mac
  # with nothing holding it awake.
  if [[ -n ${1:-} ]] && ! kill -0 "$1" 2>/dev/null; then
    echo "blank: no such process: $1" >&2
    return 1
  fi
  osascript -e 'quit app "KeepingYouAwake"' 2>/dev/null
  if [[ -n ${1:-} ]]; then
    nohup caffeinate -i -w "$1" >/dev/null 2>&1 &
    echo "blank: awake until $1 exits, display sleeping. 'unblank' to stop."
  else
    nohup caffeinate -i >/dev/null 2>&1 &
    echo "blank: awake until 'unblank', display sleeping."
  fi
  print -r -- $! > "$(_blank_pidfile)"
  disown
  sleep 1
  pmset displaysleepnow
}

unblank() {
  local pid
  if pid=$(_blank_running); then
    kill "$pid" 2>/dev/null && echo "blank: released."
  else
    echo "blank: nothing running."
  fi
  rm -f "$(_blank_pidfile)"
}
