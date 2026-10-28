#!/bin/sh
# guard-bash.sh: Claude Code PreToolUse hook for Bash.
# Blocks a force push to main or master, and rm -rf on a path outside the repo.
# Reads the hook JSON on stdin. Exit 2 blocks the call and shows the message to the agent.
# This is a guardrail for honest mistakes, not a sandbox.

input=$(cat)

json() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$input" | jq -r "$1 // empty"
  else
    key=${1##*.}
    printf '%s' "$input" | sed -n "s/.*\"$key\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" | head -n 1
  fi
}

cmd=$(json '.tool_input.command')
cwd=$(json '.cwd')
[ -n "$cwd" ] || cwd=$(pwd)
cwd=$(cd "$cwd" 2>/dev/null && pwd -P) || cwd=$(pwd -P)
[ -n "$cmd" ] || exit 0

block() {
  echo "Blocked by guard-bash: $1" >&2
  exit 2
}

root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || root=$cwd

# Force push to main or master.
if printf '%s' "$cmd" | grep -Eq 'git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+push'; then
  if printf '%s' "$cmd" | grep -Eq '(^|[[:space:]])(-f|--force|--force-with-lease)([=[:space:]]|$)|[[:space:]]\+[^[:space:]]+'; then
    branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
    if printf '%s' "$cmd" | grep -Eq '(^|[[:space:]:+/])(main|master)([[:space:]]|$)' ||
      [ "$branch" = main ] || [ "$branch" = master ]; then
      block "force push to main/master is not allowed. Push a branch and open a PR."
    fi
  fi
fi

# rm -rf outside the repo.
check_target() {
  t=$1
  case $t in
    '~'*) t="$HOME${t#\~}" ;;
  esac
  case $t in
    *'$'* | *'`'*) block "rm -rf on '$1' cannot be checked. Use a literal path inside the repo." ;;
  esac
  case $t in
    . | ./ | '*' | "$root" | "$root/") block "rm -rf on '$1' would remove the whole repo." ;;
  esac
  case "/$t/" in
    */../*) block "rm -rf on '$1' uses '..'. Use a path inside the repo." ;;
  esac
  case $t in
    /*) abs=$t ;;
    *) abs="$cwd/$t" ;;
  esac
  case $abs in
    "$root"/?*) ;;
    *) block "rm -rf on '$1' is outside the repo ($root)." ;;
  esac
}

set -f
in_rm=0
recursive=0
force=0
targets=""
finish_rm() {
  if [ "$in_rm" = 1 ] && [ "$recursive" = 1 ] && [ "$force" = 1 ]; then
    for t in $targets; do check_target "$t"; done
  fi
  in_rm=0; recursive=0; force=0; targets=""
}
for w in $cmd; do
  sep=0
  case $w in
    *';' | *'&&' | *'||' | *'|') sep=1; w=${w%;}; w=${w%&&}; w=${w%||}; w=${w%|} ;;
  esac
  case $w in
    '&&' | '||' | ';' | '|' | '') finish_rm; continue ;;
  esac
  if [ "$in_rm" = 1 ]; then
    case $w in
      --recursive) recursive=1 ;;
      --force) force=1 ;;
      --*) ;;
      -*)
        case $w in *[rR]*) recursive=1 ;; esac
        case $w in *f*) force=1 ;; esac
        ;;
      *) targets="$targets $w" ;;
    esac
  elif [ "$w" = rm ] || [ "$w" = /bin/rm ]; then
    in_rm=1
  fi
  [ "$sep" = 1 ] && finish_rm
done
finish_rm

exit 0
