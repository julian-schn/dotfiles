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

# ---- fzf (fuzzy finder: ⌃R history, ⌃T files, ⌥C cd) ----
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  export FZF_DEFAULT_OPTS='--color=light --height=40% --layout=reverse'
  source <(fzf --zsh)
fi

# ---- Aliases & functions ----
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# ---- PATH ----
export PATH="$HOME/.local/bin:$PATH"

# Antigravity IDE (agy-ide, antigravity-ide)
if [[ -d "$HOME/.antigravity-ide/antigravity-ide/bin" ]]; then
  export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"
fi

# Go tools (sweeper et al.)
if command -v go >/dev/null 2>&1; then
  export PATH="$PATH:$(go env GOPATH)/bin"
fi

# ---- Machine-specific overrides (gitignored) ----
# Put anything host-only here rather than editing this file — that keeps
# installer-appended junk out of version control.
_zshrc_dir="${${(%):-%x}:A:h}"
[[ -f "$_zshrc_dir/.zshrc.local" ]] && source "$_zshrc_dir/.zshrc.local"
unset _zshrc_dir
