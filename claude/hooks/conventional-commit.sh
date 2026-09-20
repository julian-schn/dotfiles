#!/usr/bin/env bash
# PreToolUse(Bash) hook: reject commit subjects that aren't Conventional Commits.
#
# settings.json narrows this to `git commit*` via the hook's `if` field, but that
# filter has been observed firing on commands with no `git commit` in them at all, so
# this script re-checks for itself rather than trusting it. Exit 2 blocks the tool call
# and hands stderr back to Claude, which rewrites the message and retries — that's the
# part CLAUDE.md can't do.
#
# Scope is deliberately narrow: structure and trailing period only. Lowercase-first is
# NOT enforced, because `fix: JSON parser crash` is legitimate and a blocking hook that
# rejects it is worse than a CLAUDE.md nudge that occasionally slips.
#
# Exit 0 -> allow.  Exit 2 -> block, reason on stderr.

set -euo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

# Guard: only ever inspect actual commit calls. Without this, any command that merely
# contains something shaped like -m gets parsed for a commit subject.
case "$cmd" in
  *git*commit*) ;;
  *) exit 0 ;;
esac

# `-m` must be followed by whitespace, `=`, or an opening quote. Requiring that is what
# stops long flags that merely start with -m (`-maxdepth`, `-mtime`, `-mmin`) from being
# read as `-m` plus a subject, which produced bogus rejections like "axdepth".
#
# Pull the first -m / --message argument out of the command line, honouring double
# quotes, single quotes, and bare words. Scans the whole string, so compound commands
# like `git add -A && git commit -m ...` work. \u0027 is jq's escape for an apostrophe;
# using it keeps the jq program free of apostrophes so bash single-quoting stays intact.
subject=$(printf '%s' "$input" | jq -r '
  [ (.tool_input.command // "")
    | capture("(?:^|\\s)(?:--message|-m)(?:\\s*=\\s*|\\s+)(?:\"(?<dq>[^\"]*)\"|\u0027(?<sq>[^\u0027]*)\u0027|(?<bare>\\S+))")
  ]
  | if length == 0 then "" else (.[0] | .dq // .sq // .bare) end
')

# No inline message: editor commit, `--amend --no-edit`, or `-F file`. Nothing to check.
[ -n "$subject" ] || exit 0

# Command substitution defeats static extraction — we'd be validating `$(cat` or similar.
# Don't guess and don't block: a false block here would loop.
# shellcheck disable=SC2016  # the literal characters are the point, not expansion
case "$subject" in
  *'$('* | *'`'*) exit 0 ;;
esac

types='feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert'

if ! printf '%s' "$subject" | grep -Eq "^($types)(\([a-z0-9._/-]+\))?!?: .*[^.]$"; then
  cat >&2 <<EOF
Commit message rejected: "$subject"

Use Conventional Commits: type(scope): subject
  types:   $types
  subject: imperative, lowercase, no trailing period
  example: fix(install): symlink aliases.zsh so shell aliases load
EOF
  exit 2
fi
