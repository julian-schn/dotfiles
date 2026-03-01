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

# ---- Aliases & functions ----
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

true
