# Architectural Decisions

Record significant choices here. Each entry stays forever — no deletion, only additions.

## Decision format

```
## YYYY-MM-DD — <decision title>
- Decision: what was chosen and why.
- Consequences: what this affects.
```

## Current decisions (new ones added at end)

*(Add new decisions at the bottom. Do not modify old entries.)*

## 2026-11-08 — Initial memory structure

- Decision: use markdown files in repo for project memory, platform-independent.
- Consequences: works with any agent, any platform; no API keys; version-controlled with code.

## 2026-11-08 — Layering, current-task state, and event-driven updates

- Decision: separate memory into protocol (AGENTS.md) and project state (TASK.md, CONTEXT.md, DECISIONS.md, QUESTIONS.md), plus a local scratch layer (.in-progress.md); update state by event (decisions, verified steps, plan changes, resolved questions) rather than only at session end.
- Consequences: any agent can pick up the project and immediately know current work and open questions; state is compact and trackable; old history stays in SESSIONS.md/ARCHIVE.

- Decision: persistence now happens during the session, not only at its end — scratchpad `.in-progress.md` (`status: open/closed`), automatic recovery in the protocol, rescue-commit script `scripts/memory-autosave.sh`, optional pre-commit hook to sweep memory into every commit.
- Consequences: power loss / killed process no longer loses session context; recovery works by protocol; all four mechanisms are small, git-tracked and platform-independent.

## 2026-11-09 — Self-contained .project-memory folder

- Decision: all system elements live inside `.project-memory/` — `memory-autosave.sh` and the `pre-commit` hook moved into the folder, `scripts/` and `.githooks/` deleted. Hook install: `git config core.hooksPath .project-memory`.
- Alternatives considered: keep scripts outside the folder — rejected: the user wants a single self-contained folder.
- Consequences: installing the memory in another project = copying one folder; all path references updated (AGENTS.md, CONTEXT.md, both READMEs, the scripts themselves).

## 2026-11-09 — AllToAny as the single memory repo

- Decision: AllToAny is the single public repo of the memory system; older siblings (AllToZed, AllToDSH, alltoone, allToOne-setup) will be deleted by the user.
- Alternatives considered: "Смежные проекты" section with cross-links in the README — rejected: not needed once the old repos are gone.
- Consequences: AllToAny docs contain no external links to sibling repos (verified by grep); deleting them breaks nothing.