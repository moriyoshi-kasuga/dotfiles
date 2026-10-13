# Runs the PreToolUse guard against known inputs. Usage: pre-tool-use-guard-test.sh <guard>
# The cases assume "sudo", "git push", "nixos-rebuild switch" and ".env" / ".env.*" are guarded.
# Cases are single-quoted so that $(...) and backquotes reach the guard unexpanded.
# shellcheck disable=SC2016

set -euo pipefail

guard=$1
failures=0

# expect <blocked|allowed> <tool> <tool_input field> <value>
expect() {
  local want=$1 tool=$2 field=$3 value=$4 status got
  status=0
  jq -n --arg tool "$tool" --arg field "$field" --arg value "$value" \
    '{tool_name: $tool, tool_input: {($field): $value}}' |
    "$guard" >/dev/null 2>&1 || status=$?
  case $status in
  0) got=allowed ;;
  2) got=blocked ;;
  *) got="error (exit $status)" ;;
  esac
  if [[ $got != "$want" ]]; then
    printf 'FAIL: expected %s, got %s: %s %s\n' "$want" "$got" "$tool" "$value" >&2
    failures=$((failures + 1))
  fi
}

blocked() { expect blocked Bash command "$1"; }
allowed() { expect allowed Bash command "$1"; }

# Guarded commands wherever bash would run them.
blocked 'sudo ls'
blocked 'cd /tmp && sudo ls'
blocked 'ls; sudo ls'
blocked 'echo hi | sudo tee /etc/hosts'
blocked '(sudo ls)'
blocked 'if true; then sudo ls; fi'
blocked 'echo $(sudo id)'
blocked 'echo "$(sudo id)"'
blocked 'echo `sudo id`'
blocked 'diff <(sudo cat a) b'
blocked 'FOO=1 sudo ls'
blocked 'env FOO=1 sudo ls'
blocked 'timeout 5 sudo ls'
blocked 'xargs -n 1 sudo rm < list'
blocked '/usr/bin/sudo ls'
blocked '"sudo" ls'
blocked 's"ud"o ls'
blocked 'git push'
blocked 'git push --force origin main'
blocked 'git -C repo push'
blocked 'nixos-rebuild switch --flake .'

# Strings and heredocs that a shell runs.
blocked 'bash -c "sudo ls"'
blocked "sh -c 'cd /tmp && git push'"
blocked 'bash -lc "sudo ls"'
blocked 'xargs -I{} sh -c "sudo rm {}"'
blocked 'eval "sudo ls"'
blocked 'ssh host "sudo reboot"'
blocked $'bash <<\'EOF\'\nsudo ls\nEOF'
blocked 'bash <<< "sudo ls"'
blocked $'cat <<EOF\n$(sudo id)\nEOF'

# Unparseable input falls back to the text scan.
blocked 'fish -c "if true; sudo ls; end"'
blocked 'echo "unterminated; sudo ls'

# Guarded words that are only data.
allowed 'ls -la'
allowed 'man sudo'
allowed 'rg sudo'
allowed 'grep "sudo" notes.txt'
allowed "grep -rn 'git push' ."
allowed 'git commit -m "do not run sudo here"'
allowed 'git commit -m "fix: x; sudo is blocked"'
allowed 'git commit -m "git push is guarded"'
allowed $'git commit -F - <<\'EOF\'\nfix: x\n\n  sudo keepTerminfo was the default\n  git push later\nEOF'
allowed $'cat <<\'EOF\'\nsudo ls\nEOF'
allowed "echo 'sudo ls'"
allowed "nix eval .#x --apply 'x: x.security.sudo'"
allowed 'git log --grep=push'
allowed 'git status'
allowed 'git commit -m push'

# Reads through Bash.
blocked 'cat .env'
blocked 'cat < .env'
blocked 'cp .env.local /tmp/x'
blocked 'source ./config/.env'
allowed 'cat .envrc'
allowed 'git commit -m "ignore .env files"'

# Read and edit tools.
expect blocked Read file_path /work/app/.env
expect blocked Read file_path /work/app/.env.production
expect allowed Read file_path /work/app/.envrc
expect blocked Edit file_path /work/app/.env
expect blocked Write file_path /work/app/.env.local
expect allowed Write file_path /work/app/main.rs

if ((failures > 0)); then
  echo "$failures guard case(s) failed" >&2
  exit 1
fi
