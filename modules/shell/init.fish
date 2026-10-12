set -g fish_greeting ""

complete -c simplenvim --wraps nvim

fish_add_path -g ~/.local/bin

function _run_cdi
  zi
  commandline -f repaint
end

function fish_user_key_bindings
  bind ctrl-g _run_cdi
  bind ctrl-o edit_command_buffer
end

function dcr
  if test (count $argv) -eq 0
    dcd; and dcud; and dcl -f
  else
    dcd "$argv[1]"; and dcud "$argv[1]"; and dcl "$argv[1]" -f
  end
end

function dcrb
  if test (count $argv) -eq 0
    dcd; and dcudb; and dcl -f
  else
    dcd "$argv[1]"; and dcudb "$argv[1]"; and dcl "$argv[1]" -f
  end
end

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

function timer
  if test -z $argv[1]
    echo "Usage: timer <duration in seconds>"
    return 1
  end
  set -l total $argv[1]
  echo "Timer started for $total seconds..."
  for i in (seq 0 $total)
    printf "\r===== %d/%d seconds =====" $i $total
    sleep 1
  end
  printf "\nTime's up!\n"
end
