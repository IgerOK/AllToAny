#!/usr/bin/env bash
# Rescue-commit any uncommitted memory changes (crash safety).
#
# Usage: bash .project-memory/memory-autosave.sh
# Safe to run repeatedly: does nothing if .project-memory is clean.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

if [ -n "$(git status --porcelain -- .project-memory)" ]; then
  git add -- .project-memory
  ts="$(date +'%Y-%m-%d %H:%M')"
  git commit -q -m "memory: autosave $ts" || true
  echo "memory autosaved ($ts)"
else
  echo "memory clean — nothing to save"
fi
