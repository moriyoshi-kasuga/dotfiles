#!/usr/bin/env fish

set -l pane_id (tmux display-message -p '#{pane_id}')
set -l pane_path (tmux display-message -p '#{pane_current_path}')

set -l session_name (basename $pane_path)

# tmux は `.` 以降をペイン指定として読むので、末尾に `:` を付けてセッション名に限定する
while tmux has-session -t "=$session_name:" 2>/dev/null
    read -P "Session '$session_name' already exists. New name (empty to cancel): " -l new_name
    if test -z "$new_name"
        exit 0
    end
    set session_name $new_name
end

tmux new-session -d -s "$session_name" -c "$pane_path"
set -l default_pane (tmux list-panes -t "=$session_name:" -F '#{pane_id}')
# 元セッションのペインが1つだけだとjoin-paneで元セッションが消えてpopupごと終了するので、
# 後続の操作が途中で止まらないよう1回のtmux呼び出しにまとめる
tmux switch-client -t "=$session_name:" \; \
    join-pane -s "$pane_id" -t "$default_pane" \; \
    kill-pane -t "$default_pane"
