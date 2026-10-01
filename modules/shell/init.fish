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

function pyvenv --description "Python virtual environment handler"
  set -l VENV_DIR ".venv"
  set -l REQUIREMENTS_FILE "requirements.txt"
  set -l ENVRC_FILE ".envrc"

  function __pyvenv_error
    echo (set_color red)"Error:"(set_color normal) $argv
    return 1
  end

  function __pyvenv_info
    echo (set_color green)"Info:"(set_color normal) $argv
  end

  if test (count $argv) -eq 0
    __pyvenv_error "Valid actions are init, load, or save"
    return 1
  end

  if not command -q uv
    __pyvenv_error "uv not found"
    return 1
  end

  switch $argv[1]

    case init
      if test -d $VENV_DIR
        __pyvenv_error "Virtual environment already exists"
        return 1
      end

      uv venv $VENV_DIR
      or return 1

      touch $REQUIREMENTS_FILE
      # layout python は traditional venv 前提で uv 製の venv を認識しないため、
      # 直接 PATH_add で uv venv を有効化する
      echo "PATH_add $VENV_DIR/bin" > $ENVRC_FILE

      if command -q direnv
        direnv allow .
        __pyvenv_info "direnv allowed for this directory"
      end

      __pyvenv_info "Virtual environment created"
      echo "Note: Consider adding $VENV_DIR/ to .gitignore"

    case load
      if not test -d $VENV_DIR
        __pyvenv_error "No virtual environment found"
        return 1
      end

      if not test -f $REQUIREMENTS_FILE
        __pyvenv_error "$REQUIREMENTS_FILE does not exist"
        return 1
      end

      uv pip install --python $VENV_DIR/bin/python -r $REQUIREMENTS_FILE
      or return 1

      __pyvenv_info "Packages installed from $REQUIREMENTS_FILE"

    case save
      if not test -d $VENV_DIR
        __pyvenv_error "No virtual environment found"
        return 1
      end

      uv pip freeze --python $VENV_DIR/bin/python > $REQUIREMENTS_FILE
      or return 1

      __pyvenv_info "Package list saved to $REQUIREMENTS_FILE"

    case '*'
      __pyvenv_error "Valid actions are init, load, or save"
      return 1
  end
end

complete -c pyvenv -f
complete -c pyvenv -a init -d "Initialize virtual environment"
complete -c pyvenv -a load -d "Install packages from requirements.txt"
complete -c pyvenv -a save -d "Save installed packages to requirements.txt"
