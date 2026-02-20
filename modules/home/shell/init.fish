set -U fish_greeting ""

complete -c simplenvim --wraps nvim

function _run_cdi
  zi
  commandline -f repaint
end

function fish_user_key_bindings
  for mode in default insert visual
    fish_default_key_bindings -M $mode
    bind -M $mode ctrl-g _run_cdi
    bind -M $mode ctrl-o 'edit_command_buffer'
  end
  # fish_vi_key_bindings --no-erase
  # if test "$__fish_active_key_bindings" = fish_vi_key_bindings
  #   bind -M insert -m default jk force-repaint
  # end
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

  switch $argv[1]

    case init
      if test -d $VENV_DIR
        __pyvenv_error "Virtual environment already exists"
        return 1
      end

      if not command -q python3
        __pyvenv_error "python3 not found"
        return 1
      end

      python3 -m venv $VENV_DIR
      or return 1

      touch $REQUIREMENTS_FILE
      echo "source $VENV_DIR/bin/activate.fish" > $ENVRC_FILE

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

      if not test -x $VENV_DIR/bin/pip
        __pyvenv_error "pip not found inside virtualenv"
        return 1
      end

      $VENV_DIR/bin/pip install -r $REQUIREMENTS_FILE
      or return 1

      __pyvenv_info "Packages installed from $REQUIREMENTS_FILE"

    case save
      if not test -d $VENV_DIR
        __pyvenv_error "No virtual environment found"
        return 1
      end

      if not test -x $VENV_DIR/bin/pip
        __pyvenv_error "pip not found inside virtualenv"
        return 1
      end

      $VENV_DIR/bin/pip freeze > $REQUIREMENTS_FILE
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
