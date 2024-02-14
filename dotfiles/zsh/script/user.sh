#!/usr/bin/env bash
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
	args="$*"
	if [[ -z "$args" ]]; then
		tmux ls
		return
	else
		tmux ls | grep "$args"
	fi
}

ta() {
	args="$*"
	if [[ -z "$args" ]]; then
		tmux a
		return
	else
		tmux a -t "$args"
	fi
}

tk() {
	args="$*"
	if [[ -z "$args" ]]; then
		tmux kill-session
		return
	else
		tmux kill-session -t "$args"
	fi
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
