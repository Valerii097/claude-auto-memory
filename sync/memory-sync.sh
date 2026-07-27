#!/usr/bin/env bash
# Sync the memory base with its git remote. Safe to run on a timer.
# Requires: the memory base is a git repo with a writable remote.
set -u
MEMORY_DIR="${MEMORY_DIR:-$HOME/claude-memory}"
cd "$MEMORY_DIR" || exit 1
git add -A .

# Secret gate: unstage any file whose staged diff introduces key-shaped content.
PATTERN='sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}|xox[baprs]-[A-Za-z0-9-]{10,}|eyJhbGciOi[A-Za-z0-9_-]{20,}|-----BEGIN [A-Z ]*PRIVATE KEY|AIza[0-9A-Za-z_-]{30,}'
while IFS= read -r -d '' f; do
  if git diff --cached -- "$f" | grep -qE "$PATTERN"; then
    git reset -q HEAD -- "$f"
    echo "memory-sync: secret-like content in '$f' — excluded from sync, replace it with <<REDACTED>> first" >&2
  fi
done < <(git diff --cached --name-only -z)

if ! git diff --cached --quiet; then
  git commit -q -m 'memory: auto'
fi
if ! git pull -q --rebase; then
  git rebase --abort 2>/dev/null || true
  echo 'memory-sync: rebase conflict, manual fix needed' >&2
  exit 1
fi
git push -q
