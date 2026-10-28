#!/bin/sh
# tests/hooks.sh: feeds sample hook JSON to each Claude Code hook and checks the exit code.
# 0 = allowed, 2 = blocked. Run from anywhere: sh tests/hooks.sh

here=$(cd "$(dirname "$0")/.." && pwd)
hooks="$here/hooks/claude"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export TMPDIR="$tmp"

repo="$tmp/repo"
mkdir -p "$repo"
git -C "$repo" init -q -b feature 2>/dev/null || { git -C "$repo" init -q && git -C "$repo" checkout -q -b feature; }
repo=$(cd "$repo" && pwd)

pass=0
fail=0
check() {
  want=$1; hook=$2; label=$3; json=$4
  printf '%s' "$json" | sh "$hooks/$hook" 2>/dev/null
  got=$?
  if [ "$got" = "$want" ]; then
    pass=$((pass + 1)); echo "ok    $hook: $label (exit $got)"
  else
    fail=$((fail + 1)); echo "FAIL  $hook: $label (want $want, got $got)"
  fi
}
bash_json() { printf '{"session_id":"t","cwd":"%s","tool_name":"Bash","tool_input":{"command":"%s"}}' "$repo" "$1"; }
read_json() { printf '{"session_id":"t","cwd":"%s","tool_name":"Read","tool_input":{"file_path":"%s"}}' "$repo" "$1"; }
stop_json() { printf '{"session_id":"%s","cwd":"%s","stop_hook_active":false}' "$1" "$repo"; }

# guard-bash.sh
check 0 guard-bash.sh "plain push" "$(bash_json 'git push origin feature')"
check 0 guard-bash.sh "force push to a branch" "$(bash_json 'git push --force origin feature')"
check 2 guard-bash.sh "force push to main" "$(bash_json 'git push --force origin main')"
check 2 guard-bash.sh "-f push to master" "$(bash_json 'git push -f origin master')"
check 2 guard-bash.sh "+refspec to main" "$(bash_json 'git push origin +HEAD:main')"
check 0 guard-bash.sh "rm -rf inside repo" "$(bash_json 'rm -rf build dist')"
check 0 guard-bash.sh "rm without -f" "$(bash_json 'rm -r /tmp/x')"
check 2 guard-bash.sh "rm -rf absolute outside" "$(bash_json 'rm -rf /etc')"
check 2 guard-bash.sh "rm -rf home" "$(bash_json 'rm -rf ~/Documents')"
check 2 guard-bash.sh "rm -r -f with .." "$(bash_json 'rm -r -f ../other')"
check 2 guard-bash.sh "rm -rf the repo" "$(bash_json 'rm -rf .')"
check 2 guard-bash.sh "rm -rf after &&" "$(bash_json 'cd x && rm -rf /')"

# guard-secrets.sh
check 0 guard-secrets.sh "normal file" "$(read_json "$repo/src/app.ts")"
check 0 guard-secrets.sh ".env.example" "$(read_json "$repo/.env.example")"
check 2 guard-secrets.sh ".env" "$(read_json "$repo/.env")"
check 2 guard-secrets.sh ".env.local" "$(read_json "$repo/.env.local")"
check 2 guard-secrets.sh "auth json" "$(read_json "$HOME/.config/app/auth.json")"
check 2 guard-secrets.sh "proxy dir" "$(read_json "$HOME/.cli-proxy-api/token.json")"
check 2 guard-secrets.sh "hosts.yml" "$(read_json "$HOME/.config/gh/hosts.yml")"

# stop-if-backlog.sh
printf -- '- [ ] first item\n' >"$repo/backlog.md"
check 0 stop-if-backlog.sh "no .night-shift marker" "$(stop_json s1)"
touch "$repo/.night-shift"
check 2 stop-if-backlog.sh "open item" "$(stop_json s1)"
printf -- '- [x] first item #1\n- [ ] second blocked: no access\n- [ ] third need-input: which copy?\n' >"$repo/backlog.md"
check 0 stop-if-backlog.sh "only blocked or need-input left" "$(stop_json s1)"
printf -- '- [ ] loop item\n' >"$repo/backlog.md"
NIGHT_SHIFT_MAX_CONTINUES=2
export NIGHT_SHIFT_MAX_CONTINUES
check 2 stop-if-backlog.sh "loop guard 1/2" "$(stop_json s2)"
check 2 stop-if-backlog.sh "loop guard 2/2" "$(stop_json s2)"
check 0 stop-if-backlog.sh "loop guard reached" "$(stop_json s2)"

echo "passed: $pass, failed: $fail"
[ "$fail" = 0 ]
