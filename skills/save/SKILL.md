---
name: save
description: Save important knowledge from the current conversation to your personal Markdown knowledge base (Obsidian-compatible). Triggered by "/save", "save this", "remember this". Extracts decisions, fixes, commands and open problems; delegates file writing to the memory-saver subagent (cheap model). Never edits old content — only appends `## /SAVE #N — date` sections to existing files.
---

# /save

Save knowledge from the current conversation into your Markdown knowledge base.

**Memory base:** `~/claude-memory` — edit this line if your vault lives elsewhere. All paths below are relative to this base. Write memory files in the user's language.

**Division of labor:** the main model (whatever you are chatting with) does only what requires seeing the chat — extracting facts and picking the scenario. All file mechanics (folders, formats, indexes) are done by the `memory-saver` subagent running on a cheaper model, so long chats don't burn expensive-model usage on file I/O.

## What to save — the value test

Main test for every fact: **"will this line change someone's actions two weeks from now?"** If not — don't save it.

Priority (top first):
1. **Invariants and rules** — "always X, never Y, because Z". The most valuable kind: it prevents future mistakes
2. **Root causes, not symptoms** — what exactly was broken and why the fix is correct. "Fixed the sync bug" is noise; "pull compared raw files against redacted ones, hence eternal conflicts" is knowledge
3. **Decisions with rejected alternatives** — "X instead of Y, because Z", so you never re-evaluate Y from scratch
4. **Exact identifiers** — commands, paths, IDs, ports, versions, branch/PR names: things impossible to recall from memory
5. **Open loops 🔴** — undeployed fixes, unverified assumptions, contradictions
6. Tools, links, vocabulary worth keeping

**Do NOT save:**
- The journey ("tried A, then B, then C") — only the outcome and the root cause; exception: a dead end that is *tempting to retry* (then: why it fails)
- Anything obvious from the code or git history
- General knowledge about technologies — the model already knows it
- Chit-chat, "ok/got it", intermediate versions of decisions, duplicates of already-saved facts

**Check before writing:** every fact must contain something concrete — a number, a path, a name, a reason. A fact without specifics is a paraphrase; drop it or sharpen it.

## Secrets

NEVER write API keys, tokens, passwords or connection strings into memory — replace them with `<<REDACTED>>`. The memory base may live in a git repository and sync between machines.

## Algorithm (main model)

### 1. Find the boundary

Look for a previous `/save` invocation in this chat's history.
- Found → save ONLY what happened after the last one
- Not found → save everything important from the whole conversation

⚠️ In a very long chat, early details may already be compacted away by context summarization. If you can see the start of the conversation was trimmed — say so honestly in your report and suggest saving mid-session next time.

### 2. Pick the scenario (only chat history can tell)

- **A** — first `/save` in this chat → new file
- **B** — repeat `/save` in the same chat → append to the file linked in your previous save report
- **C** — new chat, new topic → new independent file. Do NOT attach to existing files unless the user explicitly asks
- **D** — user explicitly said "this continues X" → part-file (chain)

### 2.5 Identify the project and folder (BEFORE the brief — only you see the chat)

The rule is "one project = one folder" — details in `topics.md`. If the conversation is about a specific project:
- the project already has a folder → pass it in the brief
- the project is NEW (its own repo/bot/deliverable, even on a familiar stack) → ask the user: `Create a new folder <Name/> for this project?` and pass the answer in the brief
- in doubt whether it's part of [X] or separate → ask. Never merge two projects silently

Ask the user BEFORE calling the subagent — it cannot see the chat and cannot ask follow-ups.

### 3. Build the brief and call the subagent

Call the Agent tool: `subagent_type: "memory-saver"`, `run_in_background: false`. Put into the brief EVERYTHING the subagent cannot learn on its own (it does not see the chat):

```
Date: YYYY-MM-DD (today's real date)
Scenario: A/B/C/D. For B/D — target file: [[Folder/name]]
Folder: <exact folder from step 2.5; for a new project — "create new folder <Name/>">
Topic: one line
Facts to save:
- [filtered by the priorities above — specifics: commands, paths, decisions, root causes]
Open problems 🔴: [undeployed / unverified / contradictions — or "none"]
Multiple topics → list them separately: the subagent creates one file per topic.
```

Write the facts out in full — the subagent records ONLY what is in the brief and invents nothing.

### 4. Relay the subagent's report

One-two lines from its result: `✅ Created [[...]]` / `✅ Appended /SAVE #N to [[...]]`. If the subagent returned a question (e.g. no matching folder) — ask the user and call it again.

## Fallback — if the Agent tool is unavailable

Do everything yourself using the full rules: `algorithm.md` (scenarios, part-files), `examples.md` (formats), `topics.md` (folder mapping). Key rules: append-only; `N = count("^## /SAVE #") + 2`; only `updated:` changes in frontmatter; wikilinks in frontmatter are quoted; main.md — one file = one row ≤ 200 chars, rows only inside the table; Days files are `# YYYY-MM-DD` with no frontmatter; 📌 block when a file has 3+ save sections or an open problem 🔴.

## Conventions

- Files: lowercase kebab-case, English filenames
- Wikilinks: `[[Folder/name]]` with the full path, no `.md`
- Dates: ISO `YYYY-MM-DD`
- File contents: the user's language
