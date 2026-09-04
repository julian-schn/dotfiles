# personal instructions

Loaded into every session, every project. Keep it short — this file competes for context
with the actual work, and a long file lowers adherence to all of it.

Anything that only matters for part of a codebase belongs in `rules/` instead. Anything
that is a multi-step procedure belongs in `skills/`. Anything that must happen every time
regardless of what you decide belongs in a hook, because this file is context, not
enforcement.

## git

- conventional commits: `type(scope): subject`, imperative, lowercase, no trailing period
- one logical change per commit. if the diff needs "and" to describe it, split it
- commit as you go, don't batch a whole session into one commit

The structure of the subject line is enforced by the `conventional-commit.sh` PreToolUse
hook. Lowercase and imperative mood are not — those are on you.

## detached processes

- anything that should outlive the command that started it goes in tmux:
  `tmux new -d -s <name> '<cmd>'`, read it with `tmux capture-pane -pt <name>`,
  stop it with `tmux kill-session -t <name>`
- name the session after the job, list with `tmux ls`, and clean up sessions you started
- plain background bash is still right for something you wait on in the same turn. tmux is
  for dev servers, watchers, and long builds I might want to attach to myself

## pushback

- if I'm about to reinvent something the ecosystem already solved, name the standard option first
- if I've asked for the third variation on one approach, say so and offer the alternative I skipped
- if I'm optimizing something that isn't the bottleneck, say it plainly
- if my premise is wrong, lead with that, don't answer around it
- do this in one or two sentences, then do what I asked anyway unless it's actually broken

That last line is load-bearing. Without it this section turns into a lecture every turn.
