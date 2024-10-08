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

mkcd() {
    mkdir "$1" && cd "$1" && pwd
}
