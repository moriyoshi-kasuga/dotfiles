#!/usr/bin/env bash

dcr() {
    dcd "$1" && dcud "$1" && dcl "$1" -f
}

dcrb() {
    dcd "$1" && dcudb "$1" && dcl "$1" -f
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
