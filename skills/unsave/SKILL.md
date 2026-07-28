---
name: unsave
description: Undo the most recent /save — remove the last saved section or file from the memory base, plus its index entries, after showing the user exactly what will be removed. Triggered by "/unsave", "undo that save", "roll back the last save". Always confirms before touching anything.
---

# /unsave

Revert exactly one save from the memory base.

**Memory base:** `~/claude-memory` — edit this line if your vault lives elsewhere.

Because saves are append-only, an undo is well-defined: a save only ever **appended a trailing `## /SAVE #N` section** to a file or **created a new file** — plus one line in `Days/` and one row in `main.md`. `/unsave` removes exactly that, nothing else.

## Algorithm (main model)

### 1. Find the target

- `/unsave` (no argument) → the most recent save: open the newest `Days/*.md`; its LAST entry line is the last save. A `(/SAVE #N)` marker means it was an append; no marker means the file was created by that save.
- `/unsave [[Folder/name]]` → the last `## /SAVE #N` section of that file; if the file has no `/SAVE #` sections, the target is the whole file.

### 2. Preview and confirm — ALWAYS

Show the user what exactly will be removed before doing anything:
- the file, and either the section heading with its date (`## /SAVE #4 — 2026-07-27`) or "the entire file (it was created by this save)"
- that the matching `Days/` line and `main.md` row will be cleaned up too

Wait for an explicit yes. Never skip this step — an undo deletes knowledge.

### 3. Delegate execution

Call the Agent tool: `subagent_type: "memory-undoer"`, `run_in_background: false`. Brief:

```
Target file: <absolute path>
Action: remove-last-section  (or: remove-file)
Section: ## /SAVE #N — YYYY-MM-DD   (for remove-last-section)
Days file: <absolute path of Days/YYYY-MM-DD.md>
Days line to remove: "<the exact line>"
main.md: remove the file's row   (or: update the row to reflect the remaining content)
```

### 4. Relay the report

E.g. `↩️ Removed /SAVE #4 from [[Memory-System/setup]] + cleaned Days and main.md`.

## Notes

- One save at a time. If a session saved several files, run `/unsave` once per file — the preview tells you what's next.
- If the base is a git repo, the removed content still exists in git history — `/unsave` is a tidy-up, not secure deletion.
- Only the LAST section of a file can be undone (append-only makes anything else ambiguous). To remove older content, edit the file by hand.

## Fallback — if the Agent tool is unavailable

Do it yourself following the execution rules in `agents/memory-undoer.md` (they describe the exact edits for both actions).
