#!/bin/sh
# guard-secrets.sh: Claude Code PreToolUse hook for Read and Edit.
# Blocks files that usually hold secrets: .env*, *auth*.json, ~/.cli-proxy-api/*, hosts.yml.
# .env.example and .env.sample are allowed. Exit 2 blocks the call and shows the message to the agent.

input=$(cat)

if command -v jq >/dev/null 2>&1; then
  path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.path // empty')
else
  path=$(printf '%s' "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)
fi
[ -n "$path" ] || exit 0

name=${path##*/}

block() {
  echo "Blocked by guard-secrets: '$path' usually holds secrets. Use env vars and do not read or print them." >&2
  exit 2
}

case $name in
  .env.example | .env.sample) exit 0 ;;
  .env*) block ;;
  *auth*.json) block ;;
  hosts.yml) block ;;
esac

case $path in
  */.cli-proxy-api/* | '~/.cli-proxy-api/'*) block ;;
esac

exit 0
