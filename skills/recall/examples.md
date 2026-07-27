# /recall — report examples

## Regular report (3-5 files)

```
Found 3 files on Bots:

- **[[Bots/news-bot-setup]]** (2026-04-17) — webhook setup, tokens in .env
- **[[Bots/news-bot-deploy]]** (2026-04-17) — docker-compose deploy
- **[[Bots/api-rate-limits]]** (2026-04-15) — 30 messages/sec cap

Key facts: the bot uses python-telegram-bot v21, webhook behind an nginx reverse proxy.

Want me to read one of them in full, or is this enough?
```

## Chain (part-files)

```
Found the "News Bot Setup" series (3 parts, latest — 2026-05-08):

- **[[Bots/news-bot-setup]]** (part 1, 2026-04-17) — initial webhook config
- **[[Bots/news-bot-setup-part-2]]** (part 2, 2026-04-24) — added rate limiting
- **[[Bots/news-bot-setup-part-3]]** (part 3, 2026-05-08) — cache fix
```

## Multi-save file

```
[[Memory-System/setup]] contains 3 entries:

- **#1** (2026-04-17) — created the system, 4 scenarios
- **#2** (2026-04-17) — save-boundary logic, `## /SAVE #N` format
- **#3** (2026-04-24) — audit: 6 bugs fixed
- 🔴 open: the sync timer is not deployed yet

Want a summary of the evolution or one specific entry?
```

## By date

```
On 2026-04-17 you worked on:

- **[[Memory-System/setup]]** — memory system rework (3 entries that day)
- **[[Bots/news-bot-setup]]** — bot setup

Probably related — want to start with one of them?
```

## Nothing found

```
Nothing saved on "supabase" yet.

Maybe try: "postgres", "database"? Or check the folder map in [[main]].
```

## No argument

```
Your memory base (14 files):

- **Bots** (5) — news-bot-setup, api-rate-limits, deploy, webhook-debug, envs
- **Infra** (3) — nginx-config, docker-setup, firewall
- **Web** (2) — landing, seo-notes
- **Memory-System** (3) — setup, audit, sync
- **General** (1) — misc

What are you looking for?
```
