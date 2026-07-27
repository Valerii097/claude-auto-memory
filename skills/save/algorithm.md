# /save — detailed algorithm

Read this file ONLY when SKILL.md lacks detail (scenario D or an edge case).

## Scenario A — first `/save` in this chat

**Detect:** no previous `/save` invocations in the chat history.

**Do:** create a new file using the standard layout (`examples.md` → "Standard file").

## Scenario B — same chat, repeat `/save`

**Detect:** a previous `/save` in this chat + your earlier report contains a `[[...]]` link.

**Do:** APPEND a new section to the end of that same file.

**CRITICAL RULES:**

1. **Never touch old content** — no rewording, no deletions
2. **Append at the very end**, separated by `---`
3. **Heading:** `## /SAVE #N — YYYY-MM-DD`
   - `N = count + 2`, where count = number of existing `^## /SAVE #` lines (use Grep)
   - The first save has NO `## /SAVE #1` heading — the file itself is save #1; numbering starts at #2
4. **Frontmatter:** change ONLY `updated:`. Do not touch `title:`, `created:`, `tags:`. Do not add new fields
5. **File size:** if the file exceeds ~1500 words and another save is coming — offer the user a part-2 file instead

**Structure of a `/SAVE #N` section:** a short intro plus bullets or sub-headings. New mistakes go into their own "Mistakes and fixes (new)" block. Don't repeat the full file template.

## Scenario C — new chat, new topic

**Detect:** no previous `/save` here, the user did NOT call it a continuation.

**Do:** a new independent file. Do not link it to existing files even if the topic looks similar — the user decides what connects, not you.

## Scenario D — new chat, explicit continuation

**Detect:** the user explicitly said "this continues [[Bots/news-bot-setup]]", "attach this to news-bot-setup".

**Do:** create a part-file in the same folder.

**Naming:** `<base-name>-part-N.md`, N = highest existing part + 1 (a base file without a part suffix counts as part 1).

**Frontmatter of the new part-file:**
```yaml
---
title: News Bot Setup (part N)
created: 2026-05-08        # real current date
updated: 2026-05-08
tags: [bots, news-bot]
part: N
continues_from: "[[Bots/news-bot-setup]]"   # ALWAYS points to the FIRST file of the chain
---
```
⚠️ A wikilink inside frontmatter is ALWAYS quoted: `"[[...]]"`. Unquoted, YAML parses `[[x]]` as a nested list and Obsidian Properties break. In the body — unquoted as usual.

**Quote at the top, under `# Title`:**
```markdown
> **Start:** [[Bots/news-bot-setup]] (2026-04-17)
> **Previous part:** [[Bots/news-bot-setup-part-2]] (2026-04-24)   ← only for part-3+
```

**In the previous file (when creating part-2), edit ONLY these spots:**
1. Frontmatter: add `part: 1`, `continues_in: "[[Bots/news-bot-setup-part-2]]"`; bump `updated:`
2. Add ONE line under `# Title`:
   ```markdown
   > **Continued in:** [[Bots/news-bot-setup-part-2]] (2026-05-08)
   ```

**When creating part-3, part-4, …:**
- Only the previous part changes (part-2 gets `continues_in:` + the "Continued in" quote pointing to part-3)
- The base file is NOT touched — its `continues_in:` and quote keep pointing to part-2
- Rule: the "Continued in" quote in every file always mirrors that file's own `continues_in:` — it points to the NEXT part, not the newest. The chain is base → part-2 → part-3; `/recall` walks it to the end
- At most ONE "Continued in" quote per file

**Don't forget:** add the new part-file to `Days/YYYY-MM-DD.md` and `main.md`.

## Edge cases

**The user said "save this" mid-conversation, not as a command** — if it is clearly a request to save, run scenario A or B. If ambiguous, ask: "Run /save now?"

**The topic fits no existing folder** — do NOT create a folder silently; ask which folder to use or whether to create a new one.

**The same article appears several times in a Days file (repeat saves)** — add a NEW line with a `(/SAVE #N)` marker and a description of the DELTA (what's new), not the full file description.

**main.md grows past ~100 rows** — suggest splitting into per-folder sub-indexes.
