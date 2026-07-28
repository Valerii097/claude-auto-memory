# Claude Auto Memory

![Claude Auto Memory](assets/banner.png)

**Give Claude Code a memory that survives the chat.** Three skills — `/save`, `/recall`, `/unsave` — that turn your conversations into a personal, Obsidian-compatible Markdown knowledge base. Local files, your language, no databases, no lock-in.

## The problem

Every Claude Code session starts from zero. You spend an evening debugging a nasty sync issue, make three smart decisions, find the one command that fixes everything… and tomorrow Claude remembers none of it. You re-explain your project. You re-discover the same dead ends. The knowledge existed — for exactly one chat.

## What this does

```
you ──/save──▶ main model extracts what mattered ──brief──▶ memory-saver (cheap model) writes files
you ◀─report── main model relays                  ◀─done───┘
```

Type `/save` at the end of a working session. Claude filters the conversation through a value test — *"will this line change someone's actions two weeks from now?"* — and writes the survivors into tidy Markdown notes: decisions with their reasons, root causes (not symptoms), exact commands and paths, and open problems marked 🔴.

Next week, in a brand-new chat:

> **you:** /recall news bot
>
> **Claude:** Found **[[Bots/news-bot-setup]]** (3 entries, last 2026-05-08) — webhook behind nginx, token lives in `.env`, rate limit is 30 msg/sec. 🔴 open: the retry fix is written but not deployed.

Saved something you regret? `/unsave` shows you exactly what the last save wrote and removes it after you confirm.

## Why you might like this design

- **Plain Markdown + wikilinks.** Your memory is yours: readable in Obsidian or any editor, greppable, diffable, versioned in git. No embeddings, no vector store, nothing to host.
- **Append-only.** A save never rewrites old knowledge — it appends a dated `## /SAVE #N` section. History is never destroyed; a `📌 Current state` block on top keeps recall fast.
- **Cheap.** In a long chat, every tool call re-sends the whole conversation to the expensive model. Here the expensive model makes *one* call (the brief), and a subagent on a cheaper model does the 8-12 file operations in a tiny context.
- **Explicit.** Nothing runs behind your back. `/save` and `/recall` fire only when you ask.
- **Battle-tested rules.** One project = one folder (two bots on the same stack are still two projects — Claude asks instead of guessing). Secrets never reach the files: they become `<<REDACTED>>`, and a mechanical gate double-checks before any git push.

## Install

**Windows (PowerShell):**
```powershell
git clone https://github.com/Valerii097/claude-auto-memory
cd claude-auto-memory
.\install.ps1                          # default base: %USERPROFILE%\claude-memory
.\install.ps1 -MemoryPath "D:\vault"   # or your Obsidian vault
```

**macOS / Linux:**
```bash
git clone https://github.com/Valerii097/claude-auto-memory
cd claude-auto-memory
./install.sh                 # default base: ~/claude-memory
./install.sh ~/my-vault      # or your Obsidian vault
```

The installer copies `skills/save`, `skills/recall`, `skills/unsave` into `~/.claude/skills/` and the three agents into `~/.claude/agents/`, pointing them at your memory base. Restart Claude Code afterwards — that's it.

## Configure

1. **Topics → folders.** Edit `~/.claude/skills/save/topics.md` — replace the sample folders (`Bots/`, `Infra/`, …) with your projects. This one table is the single source of truth for all skills.
2. **Language.** Memory files are written in *your* language automatically; filenames stay English kebab-case.
3. **Model for the file work.** The agents default to `model: sonnet`; change the frontmatter to `haiku` for maximum thrift.

## Use

| You say | What happens |
|---------|--------------|
| `/save` (or "save this") | Facts from the conversation are filtered and written into your base + the day index + the master index |
| `/save` again in the same chat | Appends a `## /SAVE #2 — date` section to the same file — never overwrites |
| `/recall Bots` | Browses a folder and reports with links |
| `/recall webhook` | Content search across the base (index noise filtered out) |
| `/recall 2026-04-17` | What you worked on that day |
| "this continues [[Bots/news-bot]]" + `/save` | Creates a linked `part-2` file chain |
| `/unsave` | Undoes the most recent save (with a confirmation preview): removes the last `## /SAVE #N` section — or the file that save created — plus its `Days/` line and `main.md` row |

### The base it builds

```
claude-memory/
├── main.md          ← master index: one table row per article
├── Days/            ← daily indexes (# YYYY-MM-DD, wikilinks to what you did)
│   └── 2026-04-17.md
├── Bots/            ← your topic folders (from topics.md)
│   └── news-bot-setup.md
└── ...
```

Open the base as an Obsidian vault and the wikilinks, backlinks and graph just work.

## Optional: sync between machines (PC ↔ server)

If you run Claude Code on several machines (e.g. a laptop and a VPS agent), make the base a git repo with a private remote, then wire up `sync/`:

1. **Every machine:** clone the base; install the skills with that path.
2. **Concurrent appends merge themselves:** in the base repo run
   ```bash
   echo '*.md merge=union' >> .gitattributes
   ```
   — knowledge files are append-only, so `merge=union` lets git combine two machines appending to the same file instead of raising a conflict.
3. **Interactive machines:** copy `sync/memory-push.ps1` into the base, then merge `sync/hooks-example.json` into `~/.claude/settings.json` — pull on session start, push on session end.
4. **Headless machines (Linux):** copy `sync/memory-sync.sh` to `/usr/local/bin/`, the `memory-sync.service` + `.timer` units to `/etc/systemd/system/`, then `systemctl enable --now memory-sync.timer`. The base syncs every 5 minutes.

Conflict policy: commit first, `pull --rebase`, push; on a real rebase conflict the script aborts cleanly and leaves the resolution to you.

**Secrets — two layers:** the skills forbid writing keys/tokens into memory (they become `<<REDACTED>>`), and the push scripts carry a **secret gate** — any staged change that introduces key-shaped content (`sk-…`, `ghp_…`, `AKIA…`, JWTs, private keys) is excluded from the sync with a warning until you clean it. Keep the remote private regardless.

## Tips

- **Save mid-session in long conversations.** Claude Code compacts the start of very long chats; a `/save` at the very end may no longer see early details. Saving once in the middle and once at the end captures everything (repeat saves append — nothing is overwritten).
- **Let Claude remind you.** Add this line to your `~/.claude/CLAUDE.md` and Claude will offer a `/save` once when a long conversation has accumulated unsaved decisions:
  > If the conversation has grown long, contains important decisions or fixes, and there has been no /save for a while — briefly offer to run /save once (knowledge from the start of a long chat gets lost to context compaction). Do not repeat the offer.
- **`/unsave` is a tidy-up, not secure deletion.** If the base syncs via git, undone content remains in git history.

## Anatomy

```
skills/save/     SKILL.md (filter + scenarios + brief), algorithm.md (chains, edge cases),
                 examples.md (exact formats), topics.md (your folder map)
skills/recall/   SKILL.md (search strategies + delegation), examples.md (report formats)
skills/unsave/   SKILL.md (find the last save, confirm, revert)
agents/          memory-saver.md, memory-recaller.md, memory-undoer.md — the cheap-model workers
sync/            optional multi-machine sync (hooks + systemd timer + secret gate)
```

## License

MIT
