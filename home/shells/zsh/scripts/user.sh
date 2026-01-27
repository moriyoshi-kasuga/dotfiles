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

timer() {
  if [ -z "$1" ]; then
    echo "Usage: timer <duration in seconds>"
    return 1
  fi
  echo "Timer started for $1 seconds..."
  for ((i = 0; i < $1; i++)); do
    sleep 1
    echo -ne "\r===== $((i + 1))/$1 seconds ====="
  done
  echo -e "\nTime's up!"
}
