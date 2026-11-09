#!/usr/bin/env bash
# Memory health check (rules-aware, non-blocking on warnings).
#
# Verifies:
#  - no leftover scratchpad with status: open for too long (configurable)
#  - .in-progress.md exists when a task is open
#  - SESSIONS.md record count is reasonable
#  - referenced memory files exist (basic sanity)
#  - no obvious secrets leaked into memory files (advisory)
#
# Exit: 0 = healthy, 1 = errors found, 2 = warnings only (still OK).
set -euo pipefail

# Script lives in .project-memory/, so its parent dir is the project root.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MEM="$ROOT/.project-memory"
STATUS=0
WARN=0

fatal(){ echo "memory-check: ERROR: $*" >&2; STATUS=1; }
warn(){ echo "memory-check: WARN: $*" >&2; WARN=1; }

[ -d "$MEM" ] || { fatal "no .project-memory dir"; exit 1; }

# ---- open scratchpad age (configurable, hours) ----
OPEN_MAX_HOURS="${OPEN_MAX_HOURS:-3}"
if [ -f "$MEM/.in-progress.md" ]; then
  if grep -q '^status: open$' "$MEM/.in-progress.md" 2>/dev/null; then
    ls_sec=$(stat -c %Y "$MEM/.in-progress.md" 2>/dev/null || true)
    if [ -n "$ls_sec" ]; then
      now=$(date +%s)
      age_h=$(( (now - ls_sec) / 3600 ))
      if [ "$age_h" -ge "$OPEN_MAX_HOURS" ]; then
        warn ".in-progress.md open for ${age_h}h (>= $OPEN_MAX_HOURSh) — stale session possible"
      fi
    fi
  fi
else
  # If TASK.md says a task is in progress, scratchpad should exist
  status="none"
  if [ -f "$MEM/TASK.md" ]; then
    status=$(grep -m1 '^status:' "$MEM/TASK.md" 2>/dev/null | sed -n 's/^status: //p' || true)
  fi
  case "$status" in
    in-progress|blocked) warn "TASK.md status='$status' but .in-progress.md missing" ;;
  esac
fi

# ---- sessions count sanity (configurable upper bound) ----
MAX_SESSIONS="${MAX_SESSIONS:-12}"
cnt=$(grep -cE '^## [0-9]{4}-[0-9]{2}-[0-9]{2}' "$MEM/SESSIONS.md" 2>/dev/null || true)
if [ "$cnt" -gt "$MAX_SESSIONS" ]; then
  warn "SESSIONS.md has $cnt sessions (>$MAX_SESSIONS) — consider rotation"
fi

# ---- referenced memory files exist ----
for f in CONTEXT.md DECISIONS.md SNSIONS.md; do :; done
for f in CONTEXT.md DECISIONS.md SESSIONS.md; do
  [ -f "$MEM/$f" ] || fatal "missing $f"
done

# ---- secret scan (advisory) ----
if grep -nERE '(?i)(api[_-]?key|secret|token|password|passwd)|\b([A-Za-z0-9+/]{40,})\s*$' "$MEM"/*."md" 2>/dev/null | grep -v '^[^:]*:[^:]*:#' | head -n 5 | grep -q .; then
  warn "potential secret-like string in memory files — review before push"
fi

echo "memory-check: done (errors=$STATUS, warnings=$WARN)"
exit $STATUS
