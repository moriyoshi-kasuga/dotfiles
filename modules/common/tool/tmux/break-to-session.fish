#!/usr/bin/env fish

set -l pane_id $argv[1]
set -l pane_path $argv[2]

set -l session_name (basename $pane_path)

while tmux has-session -t "=$session_name" 2>/dev/null
    read -P "Session '$session_name' already exists. New name (empty to cancel): " -l new_name
    if test -z "$new_name"
        exit 0
    end
    set session_name $new_name
end

tmux new-session -d -s "$session_name" -c "$pane_path"
set -l default_pane (tmux list-panes -t "$session_name" -F '#{pane_id}')
tmux join-pane -s "$pane_id" -t "$session_name"
tmux kill-pane -t "$default_pane"
tmux switch-client -t "$session_name"
