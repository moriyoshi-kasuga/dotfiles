#!/usr/bin/env bash

dcr() {
  if [ $# -eq 0 ]; then
    dcd && dcud && dcl -f
  else
    dcd "$1" && dcud "$1" && dcl "$1" -f
  fi
}

dcrb() {
  if [ $# -eq 0 ]; then
    dcd && dcudb && dcl -f
  else
    dcd "$1" && dcudb "$1" && dcl "$1" -f
  fi
}

useful() {
  # if exist useful.sh
  if [[ -f ./useful.sh ]]; then
    # shellcheck disable=1091
    source ./useful.sh "$@"
    return
  fi
  touch ./useful.sh
  echo "#!/usr/bin/env bash" >>./useful.sh
  echo "" >>./useful.sh
  chmod +x ./useful.sh
}

tn() {
  args="$*"
  if [ -z "$args" ]; then
    tmux new -s "$(basename "$(pwd)")"
    return
  else
    tmux new -s "$args"
  fi
}

tl() {
  if [ $# -eq 0 ]; then
    tmux ls
    return
  fi
  local list
  list="$(
    IFS='|'
    echo "$*"
  )"
  tmux list-sessions -F '#{session_name}' | grep -iE "$list"
}

ta() {
  if [ $# -eq 0 ]; then
    tmux a
    return
  fi
  tmux a -t "$(tl "$@")"
}

ts() {
  if [ $# -eq 0 ]; then
    echo "Please input session name (type tl on print session list)"
    return
  fi
  tmux switch -t "$(tl "$@")"
}

tk() {
  if [ $# -eq 0 ]; then
    tmux kill-session
    return
  fi
  tmux kill-session -t "$(tl "$@")"
}

cht() {
  curl -s "cht.sh/${*}" | less -R
}

ide() {
  tmux split-window -l 15
  sleep 0.2
  tmux split-window -h -l 66%
  sleep 0.2
  tmux split-window -h -l 50%
}

mkcd() {
  mkdir "$1" && cd "$1" && pwd
}

ask() {
  gemini -m "gemini-2.5-pro" -p "$1"
}

ggc() {
  OUTPUT=$(git diff --staged | ask "Generate a git commit message in Conventional Commits format:\n\n<type>[optional scope]: <title>\n\n<body as bullet list>\n\nRequirements:\n- First line must be the commit title\n- Then a blank line\n- Then each detailed change on its own line prefixed with '- '\n- Do not output any other text")
  TITLE=$(printf "%s" "$OUTPUT" | sed -n '1p')
  BODY=$(printf "%s" "$OUTPUT" | tail -n +3)
  if [ -z "$TITLE" ]; then
    echo "No commit message generated."
    return 1
  fi
  echo "Commit Title: "
  echo -e "    \033[1;34m$TITLE\033[0m"
  echo "Commit Body:"
  # shellcheck disable=SC2001
  echo -e "\033[1;34m$(echo "$BODY" | sed 's/^/    /')\033[0m"

  echo "Do you want to commit with this message? (Press any key to confirm)"
  if ! read -r -n 1; then
    echo "Commit cancelled."
    return 1
  fi
  git commit -m "$TITLE" -m "$BODY"
}

ggcs() {
  CHOICE=$(ask "Please suggest 10 commit messages, given the following diff:

            \`\`\`diff
            $(git diff --cached)
            \`\`\`

            **Criteria:**

            1. **Format:** Each commit message must follow the conventional commits format,
            which is \`<type>(<scope>): <description>\`.
            2. **Relevance:** Avoid mentioning a module name unless it's directly relevant
            to the change.
            3. **Enumeration:** List the commit messages from 1 to 10.
            4. **Clarity and Conciseness:** Each message should clearly and concisely convey
            the change made.

            **Commit Message Examples:**

            - fix(app): add password regex pattern
            - test(unit): add new test cases
            - style: remove unused imports
            - refactor(pages): extract common code to \`utils/wait.ts\`

            **Recent Commits on Repo for Reference:**

            \`\`\`
            $(git log -n 10 --pretty=format:'%h %s')
            \`\`\`

            **Output Template**

            Follow this output template and ONLY output raw commit messages without spacing,
            numbers or other decorations.

            fix(app): add password regex pattern
            test(unit): add new test cases
            style: remove unused imports
            refactor(pages): extract common code to \`utils/wait.ts\`

            **Instructions:**

            - Take a moment to understand the changes made in the diff.

            - Think about the impact of these changes on the project (e.g., bug fixes, new
            features, performance improvements, code refactoring, documentation updates).
            It's critical to my career you abstract the changes to a higher level and not
            just describe the code changes.

            - Generate commit messages that accurately describe these changes, ensuring they
            are helpful to someone reading the project's history.

            - Remember, a well-crafted commit message can significantly aid in the maintenance
            and understanding of the project over time.

            - If multiple changes are present, make sure you capture them all in each commit
            message.

            Keep in mind you will suggest 10 commit messages. Only 1 will be used. It's
            better to push yourself (esp to synthesize to a higher level) and maybe wrong
            about some of the 10 commits because only one needs to be good. I'm looking
            for your best commit, not the best average commit. It's better to cover more
            scenarios than include a lot of overlap.

            Write your 10 commit messages below in the format shown in Output Template section above." |
    fzf --height 40% --border --ansi --preview "echo {}" --preview-window=up:wrap)
  if [ -z "$CHOICE" ]; then
    echo "No commit message selected."
    return 1
  fi
  COMMIT_MES_FILE=$(mktemp)
  echo "$CHOICE" >"$COMMIT_MES_FILE"
  ${EDITOR:-hx} "$COMMIT_MES_FILE"
  if [ -s "$COMMIT_MES_FILE" ]; then
    git commit -F "$COMMIT_MES_FILE"
  else
    echo "Commit message is empty, commit aborted."
  fi
}
