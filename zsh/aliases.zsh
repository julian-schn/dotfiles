# ---- Aliases ----
alias cls=clear
alias home='cd ~'
alias pc='printf "%s" "$PWD" | pbcopy && echo "copied: $PWD"'
alias slog='git log --oneline'

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

POWER
  blank <pid>    Screen off, Mac keeps running until that process exits
  blank          Same, but held until you run unblank
  unblank        Let the Mac sleep normally again

GIT
  slog           Compact one-line git log

TOOLS
  sweeper        Terminal Minesweeper
"'

# ---- Functions ----
h() { cd "$HOME/${1:-}"; }
mkcd() { mkdir -p "$1" && cd "$1"; }

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
