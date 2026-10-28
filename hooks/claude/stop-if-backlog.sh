#!/bin/sh
# stop-if-backlog.sh: Claude Code Stop hook for the tero night-shift guide.
# Active only when a .night-shift file exists in the repo root.
# If backlog.md still has unticked items not marked blocked: or need-input:, it blocks the stop
# (exit 2) and tells the agent to continue. At most NIGHT_SHIFT_MAX_CONTINUES (default 20)
# continuations per session, counted in a temp file, so it cannot loop forever.

input=$(cat)

json() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$input" | jq -r "$1 // empty"
  else
    key=${1##*.}
    printf '%s' "$input" | sed -n "s/.*\"$key\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" | head -n 1
  fi
}

cwd=$(json '.cwd')
[ -n "$cwd" ] || cwd=$(pwd)
session=$(json '.session_id' | tr -cd 'A-Za-z0-9_-')
[ -n "$session" ] || session=unknown

root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || root=$cwd
[ -f "$root/.night-shift" ] || exit 0
[ -f "$root/backlog.md" ] || exit 0

open=$(grep -E '^[[:space:]]*[-*][[:space:]]+\[ \]' "$root/backlog.md" | grep -Ev 'blocked:|need-input:')
[ -n "$open" ] || exit 0

max=${NIGHT_SHIFT_MAX_CONTINUES:-20}
counter="${TMPDIR:-/tmp}/tero-night-shift-$session"
n=$(cat "$counter" 2>/dev/null || echo 0)
if [ "$n" -ge "$max" ]; then
  echo "stop-if-backlog: reached $max continuations this session. Letting the agent stop." >&2
  exit 0
fi
echo $((n + 1)) >"$counter"

count=$(printf '%s\n' "$open" | wc -l | tr -d ' ')
next=$(printf '%s\n' "$open" | head -n 1 | sed 's/^[[:space:]]*[-*][[:space:]]*\[ \][[:space:]]*//')
echo "Night shift: backlog.md has $count open item(s). Do not stop. Continue with the next one: $next. Tick it with the PR link, or mark it blocked: or need-input:." >&2
exit 2
