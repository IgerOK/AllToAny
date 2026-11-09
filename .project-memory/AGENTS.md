# Project Memory Protocol

This file is the rulebook. Read it at the start, during, and end of every session. Do not modify its content - it's the protocol, not project data.

## Before session (do these steps)

0. **Crash check + rescue** - run `bash .project-memory/memory-autosave.sh` (snapshots any uncommitted memory). Then open `.project-memory/.in-progress.md`:
   - If `status: open` → the previous session crashed. Do NOT overwrite the notes. Convert them into a new `SESSIONS.md` entry titled `## YYYY-MM-DD — Session recovered after crash` (same 5-bullet format), set the scratch file to `status: closed`, and tell the user what was recovered before continuing.
   - If `status: closed` → normal start, proceed to step 1.
1. Read `.project-memory/CONTEXT.md` - current project state
2. Read `.project-memory/TASK.md` - what is the current work, even if status is idle
3. Read `.project-memory/QUESTIONS.md` - open questions that may affect work right now
4. Read the last 3 entries in `.project-memory/SESSIONS.md` (from the end backwards)
5. If you need older info: check `.project-memory/archive/INDEX.md` → find the month → read that archive file

## During session (crash safety + event-driven state)

- Keep `.project-memory/.in-progress.md` open: `status: open`, `started: <YYYY-MM-DD>`, `request: <what you were asked>`.
- Append a short line each time a meaningful step finishes (file changed, check passed, decision made). These lines are the only record if the session dies — the next session will recover them.
- **Update state by event, not by conversation:** after a decision, a verified step, a plan change, a resolved question — update `TASK.md` (status/next step/checks/decisions), `CONTEXT.md` (project-level facts), `QUESTIONS.md` (closed/open questions) and `DECISIONS.md` as appropriate. Do NOT batch all writing until the very end.
- Do NOT close the scratch file until the session truly ends.

## After session (do these steps, in order)

1. **Append to `SESSIONS.md`** - add a new entry following this exact format. Start with a blank line:

```
## YYYY-MM-DD — <short session name>
- Request: what you were asked to do.
- Done: what you actually changed (files/modules).
- Verified: what checks you ran and result.
- Not done / limitations: what remained or couldn't be checked.
- Next: the next logical step.
```

2. **Update `TASK.md`** - set status to idle (or in-progress if there is clear continuation), update last-updated, next step, checks, blockers.

3. **Update `CONTEXT.md`** - modify any sections that changed: "Current state", "Next steps", stack info, run commands, etc.

4. **Record decisions** - if you made any architectural choices, add to `DECISIONS.md` (see below). Format:
```
## YYYY-MM-DD — <decision title>
- Decision: what was chosen and why.
- Alternatives considered: _short_.
- Consequences: what this affects.
```

5. **Optional rotation** - if `SESSIONS.md` has more than 8 entries total:
   - Create `.project-memory/archive/YYYY-MM.md` for each month with old entries
   - Move the full text of each old session into the corresponding month file
   - Keep only the last 8 entries in `SESSIONS.md` (most recent)
   - Update `.project-memory/archive/INDEX.md` - simple table (see example)

6. **Close the scratchpad** - set `.project-memory/.in-progress.md` to `status: closed`. Never leave `status: open` behind after a clean end.

If you don't mind the journal growing, skip rotation. The "8 entries" limit is a practical guideline, not a rule.

## File summary

| File | Purpose | Updated by |
| --- | --- | --- |
| `AGENTS.md` | Protocol rulebook | Never change this content |
| `CONTEXT.md` | "What is this project right now?" | Agent at every session |
| `TASK.md` | Current task / next step | Agent every session (event-driven) |
| `QUESTIONS.md` | Open questions (only unresolved) | Agent when questions arise |
| `SESSIONS.md` | Journal of all work done | Agent at every session (append-only) |
| `.in-progress.md` | Crash-safe scratchpad for the active session | Agent during session |
| `memory-autosave.sh` | Rescue commit for memory files | Agent / user, anytime |
| `memory-check.sh` | Memory health check (called by pre-commit) | — |
| `pre-commit` | Optional git hook: sweeps memory into every commit, runs `memory-check.sh` | Agent / user (opt-in: `git config core.hooksPath .project-memory`) |
| `DECISIONS.md` | Why we chose what we chose | Agent as decisions happen |
| `archive/YYYY-MM.md` | Old sessions, grouped by month | Agent (moved from SESSIONS.md) |
| `archive/INDEX.md` | Index of archived sessions | Agent (simple table) |