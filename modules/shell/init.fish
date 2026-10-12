set -g fish_greeting ""

fish_add_path -g ~/.local/bin

function _run_cdi
  zi
  commandline -f repaint
end

function fish_user_key_bindings
  bind ctrl-g _run_cdi
  bind ctrl-o edit_command_buffer
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
