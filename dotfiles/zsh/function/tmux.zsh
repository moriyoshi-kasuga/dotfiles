tn () {
    if  [[ -z "$@" ]]
    then
        tmux new -s $(basename $(pwd))
        return
    else
        tmux new -s $@
    fi
}

tl () {
    if  [[ -z "$@" ]]
    then
        tmux ls
        return
    else
        tmux ls | grep $@
    fi
}

ta () {
    if  [[ -z "$@" ]]
    then
        tmux a
        return
    else
        tmux a -t $@
    fi
}

tk () {
    if  [[ -z "$@" ]]
    then
        tmux kill-session
        return
    else
        tmux kill-session -t $@
    fi
}
