#!/usr/bin/env fish

set -l selected_path (env _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --height 100% --reverse" zoxide query -i 2>/dev/null)
if test $status -ne 0; or test -z "$selected_path"
    exit 0
end

set -l session_name (basename $selected_path)

while tmux has-session -t "=$session_name" 2>/dev/null
    read -P "Session '$session_name' already exists. New name (empty to cancel): " -l new_name
    if test -z "$new_name"
        exit 0
    end
    set session_name $new_name
end

if test -n "$TMUX"
    tmux new-session -d -s "$session_name" -c "$selected_path"
    tmux switch-client -t "$session_name"
else
    tmux new-session -s "$session_name" -c "$selected_path"
end
