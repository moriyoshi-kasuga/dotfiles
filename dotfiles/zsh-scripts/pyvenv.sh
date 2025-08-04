#!/usr/bin/env bash

# Python virtual environment handler
pyvenv() {
  local VENV_DIR=".venv"
  local REQUIREMENTS_FILE="requirements.txt"
  local ENVRC_FILE=".envrc"

  case "$1" in
  "init")
    if [[ -d "$VENV_DIR" ]]; then
      echo "Error: Virtual environment already exists"
      return 1
    fi

    # Create virtual environment
    python3 -m venv "$VENV_DIR"
    touch "$REQUIREMENTS_FILE"
    echo "source $VENV_DIR/bin/activate" >"$ENVRC_FILE"

    # Allow direnv if available
    if command -v direnv &>/dev/null; then
      direnv allow .
      echo "Info: direnv allowed for this directory"
    fi

    echo "Info: Virtual environment created"
    echo "Note: Consider adding $VENV_DIR/ to .gitignore"
    ;;

  "load")
    if [[ ! -d "$VENV_DIR" ]]; then
      echo "Error: No virtual environment found in this directory"
      return 1
    fi

    # Check if requirements file exists
    if [[ ! -f "$REQUIREMENTS_FILE" ]]; then
      echo "Warning: $REQUIREMENTS_FILE does not exist"
      return 1
    fi

    # Install packages
    pip install -r "$REQUIREMENTS_FILE"
    echo "Info: Packages installed from $REQUIREMENTS_FILE"
    ;;

  "save")
    if [[ ! -d "$VENV_DIR" ]]; then
      echo "Error: No virtual environment found in this directory"
      return 1
    fi

    # Save installed packages
    pip freeze >"$REQUIREMENTS_FILE"
    echo "Info: Package list saved to $REQUIREMENTS_FILE"
    ;;

  *)
    echo "Error: Valid actions are init, load, or save"
    return 1
    ;;
  esac

  return 0
}

# Zsh completion function for pyvenv
# shellcheck disable=2034,2152
__pyvenv_actions() {
  local -a _c
  _c=(
    'init:Initialize virtual environment'
    'save:Save package list'
    'load:Install packages'
  )

  _describe -t actions 'Actions' _c
}

# Register completion function
compdef __pyvenv_actions pyvenv
