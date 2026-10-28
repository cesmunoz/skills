# Hooks

Small guardrails that run around the agent's tool calls. They catch honest mistakes. They are not a sandbox.

## Claude Code

| Hook | Event | Does |
| --- | --- | --- |
| [guard-bash.sh](claude/guard-bash.sh) | PreToolUse, Bash | Blocks a force push to main or master, and `rm -rf` on a path outside the repo. |
| [guard-secrets.sh](claude/guard-secrets.sh) | PreToolUse, Read and Edit | Blocks files that usually hold secrets: `.env*`, `*auth*.json`, `~/.cli-proxy-api/*`, `hosts.yml`. `.env.example` and `.env.sample` are allowed. |
| [stop-if-backlog.sh](claude/stop-if-backlog.sh) | Stop | For the [night-shift](../skills/tero/guides/night-shift.md) guide. Only active when a `.night-shift` file is in the repo root. If `backlog.md` still has open items not marked `blocked:` or `need-input:`, it blocks the stop and names the next item. |

A hook blocks with exit code 2. The message goes to the agent.

The Stop hook stops itself after `NIGHT_SHIFT_MAX_CONTINUES` continuations per session (default 20). The count lives in a temp file.

### Install

1. Copy or symlink the scripts into `~/.claude/hooks/`:

   ```sh
   mkdir -p ~/.claude/hooks
   ln -s "$PWD"/hooks/claude/*.sh ~/.claude/hooks/
   ```

2. Merge the `hooks` block from [settings.hooks.json](claude/settings.hooks.json) into `~/.claude/settings.json`. Do not overwrite that file. If it has no `hooks` key, add this one. If it has one, append these entries to its `PreToolUse` and `Stop` lists. With `jq`:

   ```sh
   cp ~/.claude/settings.json ~/.claude/settings.json.bak
   jq -s '.[0] * {hooks: ((.[0].hooks // {}) as $a | .[1].hooks as $b
     | reduce ($b | keys[]) as $k ($a; .[$k] = ((.[$k] // []) + $b[$k])))}' \
     ~/.claude/settings.json.bak hooks/claude/settings.hooks.json > ~/.claude/settings.json
   ```

3. Start the night shift by creating the marker: `touch .night-shift`. Remove it when the run is over.

The scripts need `sh` and `git`. They use `jq` when it is there.

### Test

```sh
sh tests/hooks.sh
```

It feeds sample JSON to each hook and checks the exit code.

## pi

pi does not read these hooks. It uses extensions. An extension on `agent_before_settle` could do what the Stop hook does: check for `.night-shift`, count open items in `backlog.md`, and send the agent back to the next item, with the same cap. It is not built here.
