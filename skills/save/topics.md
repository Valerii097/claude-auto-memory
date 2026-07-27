# Topics → folders (single source of truth)

Both skills (`/save` and `/recall`) read this file to map the user's words to folders inside the memory base. **Customize this table for your own projects** — it ships with generic examples.

## Mapping

| Keywords (any language) | Folder |
|-------------------------|--------|
| "memory", "obsidian", "skill", "save", "recall" | `Memory-System/` |
| "server", "vps", "deploy", "docker", "nginx", "systemd" | `Infra/` |
| "bot", "telegram", "discord" | `Bots/` |
| "site", "web", "frontend", "react", "next" | `Web/` |
| name of one of your projects | `<ProjectName>/` (one folder per big project) |
| vocabulary, language learning | `Language/` |
| anything else / unclear | `General/` (create it if missing) |

## Folder separation rules

- One folder per **big ongoing project** (its name = folder name); shared infrastructure notes go to `Infra/`.
- If a conversation is about deploying project X to a server, prefer the project folder over `Infra/` — knowledge follows the project.

## New folders

If a new theme fits no existing folder — ASK the user before creating a new folder. Never create silently.

If it is unclear which existing folder fits — ask: `Is this more [Infra] or [Bots]?`
