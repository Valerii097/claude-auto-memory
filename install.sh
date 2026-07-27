#!/usr/bin/env bash
# Install the auto-memory skills and agents for Claude Code (macOS / Linux).
# Usage:  ./install.sh [/path/to/your/vault]
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
MEMORY_PATH="${1:-$HOME/claude-memory}"
SKILLS="$HOME/.claude/skills"
AGENTS="$HOME/.claude/agents"

mkdir -p "$SKILLS" "$AGENTS" "$MEMORY_PATH"

cp -r "$SRC/skills/save"   "$SKILLS/"
cp -r "$SRC/skills/recall" "$SKILLS/"
cp "$SRC/agents/memory-saver.md"    "$AGENTS/"
cp "$SRC/agents/memory-recaller.md" "$AGENTS/"

# Point every installed file at the chosen memory base.
if [ "$MEMORY_PATH" != "$HOME/claude-memory" ]; then
  find "$SKILLS/save" "$SKILLS/recall" -type f -name '*.md' \
    -exec sed -i.bak "s|~/claude-memory|$MEMORY_PATH|g" {} \; -exec rm -f {}.bak \;
  for f in "$AGENTS/memory-saver.md" "$AGENTS/memory-recaller.md"; do
    sed -i.bak "s|~/claude-memory|$MEMORY_PATH|g" "$f" && rm -f "$f.bak"
  done
fi

echo "Installed. Memory base: $MEMORY_PATH"
echo "Restart Claude Code, then try: /save  or  /recall"
