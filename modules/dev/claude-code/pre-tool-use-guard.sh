# PreToolUse hook. Exit 2 blocks the tool call and feeds stderr back to Claude.
# GUARDED_COMMANDS: newline-separated command word sequences (e.g. "git push")
# GUARDED_READS / GUARDED_EDITS: newline-separated globs. Globs without "/" match the basename.

input=$(cat)
tool=$(jq -r '.tool_name // ""' <<<"$input")

block() {
  echo "BLOCKED: $1" >&2
  exit 2
}

matches_glob() {
  local path=$1 glob
  while IFS= read -r glob; do
    [[ -z $glob ]] && continue
    if [[ $glob == */* ]]; then
      # shellcheck disable=SC2053
      [[ $path == $glob ]] && return 0
    else
      # shellcheck disable=SC2053
      [[ ${path##*/} == $glob ]] && return 0
    fi
  done <<<"$2"
  return 1
}

regex_escape() {
  # shellcheck disable=SC2001
  sed 's/[][\.*^$+?(){}|]/\\&/g' <<<"$1"
}

# Command position: start of line, after a separator/quote/subshell, optionally behind
# env assignments, wrappers (env, xargs, timeout, ...) and their options, and a path prefix.
cmd_start='(^|[;&|({`!"'"'"']|\$\()[[:space:]]*(([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*|env|command|exec|nohup|time|timeout|xargs|builtin|sudo|doas|-[^[:space:]]+|[0-9]+[smhd]?)[[:space:]]+)*([^[:space:]]*/)?'
# Options (with an optional argument) allowed between words, e.g. "git -C dir push".
word_sep='([[:space:]]+-[^[:space:]]+([[:space:]]+[^-[:space:]][^[:space:]]*)?)*[[:space:]]+'
word_end='([[:space:]]|$|[;&|)`"'"'"'])'

case $tool in
Bash)
  cmd=$(jq -r '.tool_input.command // ""' <<<"$input")

  while IFS= read -r words; do
    [[ -z $words ]] && continue
    pattern=""
    for word in $words; do
      if [[ -z $pattern ]]; then
        pattern=$(regex_escape "$word")
      else
        pattern+="$word_sep$(regex_escape "$word")"
      fi
    done
    if grep -qE "$cmd_start$pattern$word_end" <<<"$cmd"; then
      block "\`$words\` is not allowed."
    fi
  done <<<"$GUARDED_COMMANDS"

  while IFS= read -r token; do
    [[ -z $token ]] && continue
    if matches_glob "$token" "$GUARDED_READS"; then
      block "Accessing \`$token\` is not allowed."
    fi
  done < <(tr -s '[:space:];|&<>()`"'"'"'' '\n' <<<"$cmd")
  ;;
Read)
  path=$(jq -r '.tool_input.file_path // ""' <<<"$input")
  if matches_glob "$path" "$GUARDED_READS"; then
    block "Reading \`$path\` is not allowed."
  fi
  ;;
Edit | MultiEdit | Write | NotebookEdit)
  path=$(jq -r '.tool_input.file_path // .tool_input.notebook_path // ""' <<<"$input")
  if matches_glob "$path" "$GUARDED_EDITS"; then
    block "Editing \`$path\` is not allowed."
  fi
  ;;
esac

exit 0
