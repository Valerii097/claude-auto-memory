---
name: recall
description: Pull relevant knowledge from your personal Markdown knowledge base on explicit request ("/recall", "check the memory", "what do we have on X"). Never auto-triggers. Searches knowledge files, follows continues_from/continues_in chains, detects multi-save files and reports by section.
---

# /recall

Pull saved knowledge from the memory base on the user's explicit request.

**Memory base:** `~/claude-memory` — edit this line if your vault lives elsewhere.

**Never run automatically.** Only when the user explicitly asks.

## Who executes (token economy)

- **The chat is already long** (real work happened, many messages) → delegate: Agent tool, `subagent_type: "memory-recaller"`, `run_in_background: false`, put the query verbatim into the prompt; relay its report. Every tool call of yours pushes the whole chat through the expensive model — the subagent searches in a tiny context
- **Start of a chat** (recall is one of the first messages) → run the algorithm below yourself; spawning an agent isn't worth it
- Agent tool unavailable → run it yourself

## Algorithm

### 1. Parse the argument

- `/recall <folder>` (e.g. `Bots`) — browse a folder
- `/recall <word>` (e.g. `webhook`) — content search
- `/recall <date>` (e.g. `2026-04-17`) — that day's index
- `/recall` with no argument — show an overview and ask

**Word → folder mapping:** `skills/save/topics.md` in your skills directory (single source of truth shared by both skills).

### 2. Pick a search strategy

**By folder** (after mapping via `topics.md`):
```
Glob "<Folder>/**/*.md"
```

**By word:**
```
Grep "<word>" glob:"**/*.md" output_mode:files_with_matches
```
DROP `main.md`, `Days/*` and any `*/index*.md` from the results — indexes mention everything and pollute the output. Read only knowledge files in topic folders. Fall back to indexes only when topic files give zero hits (then Grep main.md to see where to look).

**By date:**
```
Read Days/2026-04-17.md
```
Follow the wikilinks from there.

**No argument:**
```
Glob "**/*.md" → count per folder, present the map
```

### 3. Read the relevant files

- 3-7 files maximum
- If frontmatter has `part:` / `continues_in:` / `continues_from:` — read the WHOLE chain in order

### 3.5 Detect multi-save files

After reading each file: `Grep "^## /SAVE #" <file>`.
- 0 hits — a regular file, report as one document
- 1+ hits — report by sections with dates

### 3.6 Optimization: read only the 📌 block first

If the user asks about the current state (not the history), first read ONLY the `📌 Current state` block (`Read offset=1 limit=20`). If it answers the question — stop there; it saves 70-80% of the tokens. Read the full file only when details or history are needed.

### 4. Report

A structured report (do NOT paste whole files):
- Links with a one-line description and date
- For chains: "X parts, latest — YYYY-MM-DD"
- For multi-save files: the list of sections with dates
- Key facts on the topic (2-4 sentences), including any open problems 🔴

### 5. Offer the next step

`Want me to read a specific file in full, or is this enough?`

## If nothing is found

`Nothing saved on this yet. Try other words: "X", "Y". Or check the folder map in [[main]].`
