#!/usr/bin/env bash

is_mac=$(uname -s | grep -qi "darwin" && echo true || echo false)
script_root=$(cd "$(dirname "$0")" && pwd)
. "${script_root}"/common.sh

notice "${BLACK}${CYAN_BG}★ Start setup Initialize"

if ! "${is_mac}"; then
  sudo apt-get -y -qq update >/dev/null 2>&1
  sudo apt-get -y -qq upgrade >/dev/null 2>&1
  sudo apt-get -y -qq clean >/dev/null 2>&1
fi

make link

sudo make brew

make zsh

make git

make node

make python

# make coursier

make vim

make neovim

sudo make docker

if "${is_mac}"; then
  sudo make darwin
else
  sudo make linux
fi

echo
notice "${BLACK}${CYAN_BG}◎ Initialize complete!. Please Terminal Reboot!."
