# PreToolUse hook. Exit 2 blocks the tool call and feeds stderr back to Claude.
# GUARDED_COMMANDS: newline-separated command word sequences (e.g. "git push")
# GUARDED_READS / GUARDED_EDITS: newline-separated globs. Globs without "/" match the basename.
#
# Bash commands are parsed with shfmt, so a guarded word only counts where bash runs it as a
# command, not inside a quoted argument or a heredoc fed to cat or git. Strings handed to a shell
# (bash -c, eval, ssh, heredocs and here-strings fed to a shell) are parsed again. If parsing fails,
# the command is scanned as plain text instead.

set -E
# A failing guard must not let the tool call through (any exit status but 2 does).
trap 'echo "BLOCKED: the guard itself failed" >&2; exit 2' ERR

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

# Words that may come before the command itself: assignments, wrappers and their options,
# durations (timeout 5), and a path prefix.
wrappers='env|command|exec|nohup|time|timeout|xargs|builtin|sudo|doas|nice|setsid|stdbuf'
prefix="(([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*|$wrappers|-[^[:space:]]+|[0-9]+[smhd]?)[[:space:]]+)*([^[:space:]]*/)?"
# Options (with an optional argument) allowed between words, e.g. "git -C dir push".
word_sep='([[:space:]]+-[^[:space:]]+([[:space:]]+[^-[:space:]][^[:space:]]*)?)*[[:space:]]+'

guarded_names=()
guarded_patterns=()
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
  guarded_names+=("$words")
  guarded_patterns+=("$pattern")
done <<<"$GUARDED_COMMANDS"

# One simple command, its words joined by single spaces.
check_command_line() {
  local i
  for i in "${!guarded_patterns[@]}"; do
    if grep -qE "^$prefix${guarded_patterns[i]}([[:space:]]|$)" <<<"$1"; then
      block "\`${guarded_names[i]}\` is not allowed."
    fi
  done
}

check_path() {
  if matches_glob "$1" "$GUARDED_READS"; then
    block "Accessing \`$1\` is not allowed."
  fi
}

# Fallback for commands shfmt cannot parse: a guarded word counts after any separator or quote.
scan_text() {
  local cmd=$1 i token
  local start='(^|[;&|({`!"'"'"']|\$\()[[:space:]]*'
  for i in "${!guarded_patterns[@]}"; do
    if grep -qE "$start$prefix${guarded_patterns[i]}([[:space:]]|$|[;&|)\`\"'])" <<<"$cmd"; then
      block "\`${guarded_names[i]}\` is not allowed."
    fi
  done
  while IFS= read -r token; do
    if [[ -n $token ]]; then check_path "$token"; fi
  done < <(tr -s '[:space:];|&<>()`"'"'"'' '\n' <<<"$cmd")
}

# Turns the shfmt AST into NUL-separated items:
#   line:<words of a simple command>  path:<a word or redirect target>  script:<text a shell runs>
# Parts of a word only known at run time (variables, command substitutions) become "_".
# shellcheck disable=SC2016
ast_filter='
  def text:
    [ .Parts[]?
      | if .Type == "Lit" then .Value | gsub("\\\\(?<c>.)"; "\(.c)")
        elif .Type == "SglQuoted" then .Value
        elif .Type == "DblQuoted" then [ .Parts[]? | if .Type == "Lit" then .Value else "_" end ] | add // ""
        else "_" end
    ] | add // "";
  def shells: "bash", "sh", "zsh", "dash", "ksh", "fish";
  def base: sub(".*/"; "");
  def is_wrapper: test("^([A-Za-z_][A-Za-z0-9_]*=|-|[0-9]+[smhd]?$)") or (base | test("^(\($wrappers))$"));
  # The words from the command itself on, past assignments and wrappers.
  def command_words: (map(is_wrapper) | index(false)) as $i | if $i == null then [] else .[$i:] end;
  def runs_scripts: (command_words | .[0] // "" | base) | IN(shells, "ssh", "eval");
  def scripts:
    command_words as $w
    | ($w[0] // "" | base) as $cmd
    | if $cmd | IN(shells) then
        ($w | to_entries | map(select(.value | test("^-[A-Za-z]*c[A-Za-z]*$"))) | first | .key) as $k
        | if $k == null then empty else $w[$k + 1] // empty end
      elif $cmd == "eval" then $w[1:] | join(" ")
      elif $cmd == "ssh" then range(1; $w | length) as $i | $w[$i:] | join(" ")
      else empty end;

  .. | objects
  | if .Type? == "CallExpr" then
      [ .Args[]? | text ] as $w
      | "line:" + ($w | map(gsub("\\s"; "_")) | join(" ")),
        ($w[] | "path:" + .),
        ($w | scripts | "script:" + .)
    elif has("Cmd") and has("Redirs") then
      ((.Cmd.Type? == "CallExpr") and ([ .Cmd.Args[]? | text ] | runs_scripts)) as $shell
      | .Redirs[]
      | if .Hdoc then (if $shell then "script:" + (.Hdoc | text) else empty end)
        elif .Op == "<<<" then (if $shell then "script:" + (.Word | text) else empty end)
        else "path:" + (.Word | text) end
    else empty end
'

check_bash() {
  local cmd=$1 depth=$2 ast item
  if ((depth > 8)) || ! ast=$(shfmt -ln bash --to-json <<<"$cmd" 2>/dev/null); then
    scan_text "$cmd"
    return
  fi
  while IFS= read -r -d '' item; do
    case $item in
    line:*) check_command_line "${item#line:}" ;;
    path:*) check_path "${item#path:}" ;;
    script:*) check_bash "${item#script:}" $((depth + 1)) ;;
    esac
  done < <(jq --raw-output0 --arg wrappers "$wrappers" "$ast_filter" <<<"$ast")
}

case $tool in
Bash)
  check_bash "$(jq -r '.tool_input.command // ""' <<<"$input")" 0
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
