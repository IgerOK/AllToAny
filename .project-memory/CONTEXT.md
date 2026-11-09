# Project Context

**Current state of the project.** Updated at the end of every session.

## 1. What this project is about

- **Name:** Оптимизация
- **Goal:** A universal project-memory system that can be distributed via GitHub and consumed by any agent from any application.
- **Problem it solves:** Agents forget project context between sessions. This repo gives any agent a platform-independent, git-versioned memory they can read before work and update after.

## 2. Stack & Environment

| Component | Value |
| --- | --- |
| Platform | Git, Bash (Git Bash on Windows) |
| Agent tooling | Freebuff / Codebuff (freebuff.com) — but the `.project-memory/` system is platform-agnostic |
| OS / dev environment | Windows, Git Bash |
| Repository | Local git repo (`main` branch, single clean commit; not pushed yet) |

## 3. How to run / build / use

**Use the memory system:**
1. Before work → read `.project-memory/AGENTS.md`, then `.project-memory/CONTEXT.md`
2. Read last 3 entries of `.project-memory/SESSIONS.md`
3. Do the requested work
4. Append entry to `.project-memory/SESSIONS.md`, update this file, optionally add to `.project-memory/DECISIONS.md`

**Git (local):**
- The repo is local only. Do NOT push to a remote without explicit user instruction.
- Commit memory updates together with code changes.

**Reference docs:**
- `README.md` (root) — full guide in Russian for distributing on GitHub and using with any agent

## 4. Current status

- Universal memory system created in `.project-memory/`:
  - `AGENTS.md` — protocol (read first, no platform deps)
  - `CONTEXT.md` — this file
  - `SESSIONS.md` — journal (append-only)
  - `DECISIONS.md` — architectural decisions
  - `archive/` — rotated old sessions, `INDEX.md` for browsing
- Original Freebuff-specific memory system removed (replaced by universal one)
- No application code yet — this repo IS the memory infrastructure
- Repo committed locally, not pushed to remote
- Crash-safety: `.project-memory/.in-progress.md` scratchpad during sessions, crash recovery in the protocol, `.project-memory/memory-autosave.sh` rescue commit, optional `.project-memory/pre-commit` git hook checks memory state (block on errors, warn on suspicious).
- Layering: memory has three layers — (L0) `AGENTS.md` the protocol (can stay project-independent in its own repo), (L1) `.in-progress.md` local scratch, (L2) `TASK.md`, `CONTEXT.md`, `DECISIONS.md`, `QUESTIONS.md` project state. When opening this project again with a new agent, read L0, then L2, then recent L2-led SESSIONS entries.
- Resume safety: on any continuation, run `bash .project-memory/memory-autosave.sh`, read L0 → L2 → recent sessions, give a short status recap, propose the next step, and wait for user confirmation before doing new work.

## 5. Next steps

- Describe the actual application project this memory will serve (if any beyond the memory system itself)
- Decide: repository strategy (standalone memory repo to be linked from other projects, or per-project memory)
- Optionally push to GitHub (requires explicit user instruction — do not push without it)
- If memory system is to be reused in other projects, consider extracting `.project-memory/` into its own dedicated repo as a template

## 6. Session bookkeeping

- **Last session focus:** Building the universal memory system; cleaning up platform-specific leftovers
- **Next logical step:** User describes the real project task/stack that this memory should track, or confirms this repo stays as a memory-template repo only