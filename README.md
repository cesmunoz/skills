# skills

## Shared agent rules

[config/agents/AGENTS.md](config/agents/AGENTS.md) holds the rules every agent follows. One file feeds every tool. Edit it here, and each tool reads it through a symlink.

| Tool | Reads | How |
| --- | --- | --- |
| pi | `~/.pi/agent/AGENTS.md` | `ln -s "$PWD/config/agents/AGENTS.md" ~/.pi/agent/AGENTS.md` |
| Claude Code | `~/.claude/CLAUDE.md` | `ln -s "$PWD/config/agents/AGENTS.md" ~/.claude/CLAUDE.md` |
| Cursor | User rules | Paste the file into Settings > Rules > User Rules, or add it as a rule file. |

Run the `ln` commands from the repo root. If the target file already exists, merge it into AGENTS.md first, then replace it with the link.

## Hooks

See [hooks/README.md](hooks/README.md).
