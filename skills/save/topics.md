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

## THE MAIN RULE: one project = one folder

Every distinct project/bot/product gets ITS OWN folder named after it. The thematic folders in the table above are only for knowledge NOT tied to a specific project.

- **A new project appears in the conversation** (its own repo / its own bot / its own deliverable) → offer to create a new `<Project-Name>/` folder. Do NOT file it under a thematic folder or under a similar project's folder
- **Same stack ≠ same project.** Two Telegram bots (one monitors crypto, one answers messages) are TWO folders, even if the technology is identical
- **In doubt whether it's the same project or a new one** → ALWAYS ask the user: `Is this part of [X] or a separate project? If separate, I'll create [Y/]`. Never merge two projects silently
- **Personas/contacts inside one codebase** (e.g. different conversation partners of one multi-bot): one project by default, but if the user seems to treat them separately — ask and split

## Folder separation rules

- Knowledge about a SPECIFIC project goes to that project's folder, even when the theme sounds generic ("deploying the bot to the server" → the bot's folder, not `Infra/`).
- `Infra/` is for infrastructure not owned by any single project.

## New folders

A new theme with no matching folder → ASK the user, never create silently. Unclear between existing folders → ask: `Is this more [Infra] or [Bots]?`
