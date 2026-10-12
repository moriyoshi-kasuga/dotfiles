# tmux は `.` 以降をペイン指定として読むので、ターゲットは末尾に `:` を付けてセッション名に限定する
function tn
  set -l name (string join " " $argv)
  if test -z "$name"
    set name (basename (pwd))
  end
  if not tmux has-session -t "=$name:" 2>/dev/null
    tmux new-session -d -s "$name" -c (pwd); or return
  end
  if set -q TMUX
    tmux switch-client -t "=$name:"
  else
    tmux attach-session -t "=$name:"
  end
end

function tl
  if test (count $argv) -eq 0
    tmux ls
    return
  end
  set -l list (string join "|" $argv)
  tmux list-sessions -F '#{session_name}' | grep -iE "$list"
end

function __tmux_pick_session --description "Print one session matching <patterns>, asking fzf when ambiguous"
  if test (count $argv) -eq 0
    tmux list-sessions -F '#{session_name}'
  else
    tl $argv
  end | fzf --select-1 --exit-0
end

function ta
  if test (count $argv) -eq 0
    tmux a
    return
  end
  set -l session (__tmux_pick_session $argv); or return
  tmux a -t "=$session:"
end

function ts
  set -l session (__tmux_pick_session $argv); or return
  tmux switch -t "=$session:"
end

function tk
  if test (count $argv) -eq 0
    tmux kill-session
    return
  end
  set -l session (__tmux_pick_session $argv); or return
  tmux kill-session -t "=$session:"
end
