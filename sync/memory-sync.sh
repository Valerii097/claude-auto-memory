#!/usr/bin/env bash
# Sync the memory base with its git remote. Safe to run on a timer.
# Requires: the memory base is a git repo with a writable remote.
set -u
MEMORY_DIR="${MEMORY_DIR:-$HOME/claude-memory}"
cd "$MEMORY_DIR" || exit 1
git add -A .
if ! git diff --cached --quiet; then
  git commit -q -m 'memory: auto'
fi
if ! git pull -q --rebase; then
  git rebase --abort 2>/dev/null || true
  echo 'memory-sync: rebase conflict, manual fix needed' >&2
  exit 1
fi
git push -q
