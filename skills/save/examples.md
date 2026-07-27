# /save — format examples

Read ONLY if you forgot the exact frontmatter or file layout.

## Standard file (scenarios A, C — first save)

```markdown
---
title: Short name
created: 2026-04-17       # real current date, never a placeholder
updated: 2026-04-17
tags: [topic, subtopic]
---

# Short name

[2-4 sentences on what this is]

## What we did
- Concrete steps / commands

## Details
[Deeper explanation, if needed]

## Mistakes and fixes
- What failed and how it was fixed

## Related
- [[Folder/other-file]] — how it relates
```

## File after several appends (scenario B)

```markdown
---
title: News Bot Setup
created: 2026-04-17
updated: 2026-04-24       # ← the ONLY frontmatter field that changes
tags: [bots, news-bot]
---

# News Bot Setup

[original content from the first save — untouched]

---

## /SAVE #2 — 2026-04-17

[what was added by the second save, same day]

---

## /SAVE #3 — 2026-04-24

[what was added a week later]
```

## 📌 Current state block

When a file has 3+ save sections OR an open problem, add/update this block between the frontmatter and `# Title` (the only permitted edit of existing content):

```markdown
> **📌 Current state (as of YYYY-MM-DD, after /SAVE #N):**
> [2-5 sentences describing the state NOW]
> 🔴 [open problems / undeployed fixes — remove this line once resolved]
```

## Days/YYYY-MM-DD.md

No frontmatter; the heading is the ISO date (one format only):

```markdown
# 2026-04-17

- [[Bots/news-bot-setup]] — configured the bot, webhook
- [[Infra/nginx-config]] — nginx as reverse proxy
- [[Memory-System/setup]] (`/SAVE #2`) — refined the rules
```

For appends: the `(/SAVE #N)` marker + the DELTA, not the full description.

## main.md — a row in the Articles table

```markdown
| [[Bots/news-bot-setup]] | Bots | News bot: webhook setup, tokens in .env, docker deploy | 2026-04-17 |
```

Rules: rows ONLY inside the Articles table; one file = one row (a repeat save updates the row, never adds another); description ≤ 200 chars made of searchable words (`webhook, tokens, docker`), not vague summaries ("set up the bot").

## Reports to the user

- New file: `✅ Created [[Bots/news-bot-setup]] + Days/2026-04-17 + main.md`
- Append: `✅ Appended /SAVE #2 to [[Memory-System/setup]] + Days/2026-04-17`
- Part: `✅ Created [[Bots/news-bot-setup-part-2]] (continues [[Bots/news-bot-setup]]) + Days/2026-04-17`
