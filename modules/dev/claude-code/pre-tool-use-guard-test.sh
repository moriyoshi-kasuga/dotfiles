# Runs the PreToolUse guard against known inputs. Usage: pre-tool-use-guard-test.sh <guard>
# The cases assume the lists in guard.nix, e.g. "sudo", "git push", "gh pr merge" and ".env".
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
blocked 'caffeinate -i git push'
blocked 'cargo +nightly publish'
blocked 'pnpm -r publish'
blocked 'docker compose -f x.yml push'

# Aliases and other commands for the same thing.
blocked 'gh pr new --fill'
blocked 'gh issue new -t x'
blocked 'gh release new v1'
blocked 'docker image push img'
blocked 'cargo release --execute'
blocked 'darwin-rebuild switch --flake .'
blocked 'nixos-rebuild boot --flake .'
blocked 'su -c ls'
blocked 'run0 ls'
blocked 'pkexec ls'

# Commands that another command runs.
blocked 'nix develop -c git push'
blocked 'nix shell nixpkgs#hello --command git push'
blocked 'direnv exec . git push'
blocked 'mise exec -- git push'
blocked 'mise x node@24 -- env FOO=1 git push'
blocked 'find . -name x -exec sudo rm {} \;'
blocked 'find . -exec echo {} + -execdir sudo rm {} \;'
blocked 'fd -x sudo rm'
blocked 'nix develop -c direnv exec . git push'
blocked 'nix develop -c bash -c "git push"'
blocked $'nix develop -c bash <<\'EOF\'\ngit push\nEOF'
allowed 'nix develop -c cargo test'
allowed 'direnv exec . git status'
allowed 'mise exec -- node -v'
allowed 'find . -name "*.nix" -exec grep -l sudo {} +'
allowed 'find . -exec echo git push \;'
allowed 'fd -e nix -x rg sudo'

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
blocked 'watch git push'
blocked "watch -n 1 'git push'"
blocked 'parallel git push ::: a'
blocked "parallel 'sudo rm {}' ::: a"
blocked $'parallel <<\'EOF\'\nsudo ls\nEOF'
blocked "nix-shell -p hello --run 'git push'"
blocked "mise exec -c 'git push'"
allowed 'watch -n 1 git status'

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
allowed 'git commit -m "gh pr merge later"'
allowed 'gh pr view 1'
allowed 'gh pr list --state open'
allowed 'docker pull img'

# gh api writes.
blocked 'gh api repos/o/r/pulls -f title=t -f head=a -f base=main'
blocked 'gh api repos/o/r/issues --raw-field=title=t'
blocked 'gh api repos/o/r/issues --input body.json'
blocked 'gh api -X POST repos/o/r/issues'
blocked 'gh api --method=DELETE repos/o/r'
blocked 'gh api -XPATCH repos/o/r'
blocked "gh api graphql -f query='mutation { addStar(input: {starrableId: \"x\"}) { clientMutationId } }'"
blocked 'gh api graphql -F query=@q.graphql'
blocked 'nix develop -c gh api repos/o/r/issues -f title=x'
allowed 'gh api repos/o/r/pulls/1/comments'
allowed 'gh api --paginate repos/o/r/issues --jq ".[].title"'
allowed 'gh api -X GET search/issues -f q=repo:o/r'
allowed 'gh api --method get search/code -F q=x'
allowed "gh api graphql -f query='query { viewer { login } }' -F n=1"

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
