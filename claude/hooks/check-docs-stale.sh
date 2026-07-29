#!/usr/bin/env bash
# Stop hook: nudge to review docs when code has changed more recently than docs.
#
# Heuristic (generic, works in any git repo): treat Markdown as documentation and
# everything else as code. If the newest commit touching a non-.md file is more
# recent than the newest commit touching any .md file, the docs are probably behind.
#
# Fires at most once per HEAD (a sentinel per-repo stores the last HEAD we fired on)
# so it never loops: once you add a doc commit — or decide nothing's needed and move
# on — it goes quiet until the next code commit.
#
# Exit 0  -> silent, nothing to do.
# Exit 2  -> asyncRewake: wake the model with the message below to review the docs.

set -euo pipefail

# Must be inside a git repo with at least one commit; otherwise nothing to compare.
repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
head=$(git rev-parse HEAD 2>/dev/null) || exit 0

# Newest commit timestamps: docs (.md) vs code (everything else). Empty -> 0.
last_doc=$(git log -1 --format=%ct -- '*.md' 2>/dev/null || true)
last_code=$(git log -1 --format=%ct -- . ':(exclude)*.md' 2>/dev/null || true)
last_doc_sha=$(git log -1 --format=%H -- '*.md' 2>/dev/null || true)
last_doc=${last_doc:-0}
last_code=${last_code:-0}

# Docs are current (or repo has no code) -> nothing to flag.
[ "$last_code" -gt "$last_doc" ] || exit 0

# De-dupe: don't fire twice for the same HEAD.
state_dir="$HOME/.claude/hooks/state"
mkdir -p "$state_dir"
key=$(printf '%s' "$repo_root" | shasum | cut -d' ' -f1)
state_file="$state_dir/$key"
[ -f "$state_file" ] && [ "$(cat "$state_file")" = "$head" ] && exit 0

# Record this HEAD, then wake the model to review.
printf '%s' "$head" > "$state_file"

if [ -n "$last_doc_sha" ]; then range="${last_doc_sha}..HEAD"; else range="HEAD"; fi
changed=$(git log "$range" --format= --name-only -- . ':(exclude)*.md' 2>/dev/null \
  | sort -u | grep -v '^$' | head -20 || true)

cat <<EOF
Code in $(basename "$repo_root") has changed since the docs were last updated.
Review whether README / CLAUDE.md / other Markdown docs need updating for these
recent non-doc changes; if they're already accurate, no action is needed.

Files changed since the last docs commit:
$changed
EOF
exit 2
