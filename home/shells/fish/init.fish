set -U fish_greeting ""

function _run_cdi
    zi
    commandline -f repaint
end

function fish_user_key_bindings
    bind \cg _run_cdi
    bind -M insert ctrl-o 'edit_command_buffer'
    
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end
    fish_vi_key_bindings --no-erase
    if test "$__fish_active_key_bindings" = fish_vi_key_bindings
        bind -M insert -m default jk force-repaint
    end
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

function tn
  set -l args (string join " " $argv)
  if test -z "$args"
    tmux new -s (basename (pwd))
    return
  else
    tmux new -s "$args"
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

function ta
  if test (count $argv) -eq 0
    tmux a
    return
  end
  tmux a -t (tl $argv)
end

function ts
  if test (count $argv) -eq 0
    echo "Please input session name (type tl on print session list)"
    return
  end
  tmux switch -t (tl $argv)
end

function tk
  if test (count $argv) -eq 0
    tmux kill-session
    return
  end
  tmux kill-session -t (tl $argv)
end

function timer
  if test -z $argv[1]
    echo "Usage: timer <duration in seconds>"
    return 1
  end
  set -l total $argv[1]
  echo "Timer started for $total seconds..."
  for i in (seq 1 $total)
    sleep 1
    printf "\r===== %d/%d seconds =====" $i $total
  end
  printf "\nTime's up!\n"
end
