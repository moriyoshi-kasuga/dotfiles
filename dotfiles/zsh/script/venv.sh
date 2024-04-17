#!/usr/bin/env bash
function pyvenv {
	local root
	root=$(pwd)
	case "$1" in
	"init")
		if [[ -d "${root}/.venv" ]]; then
			_error "すでに pyvenv が作成されています"
			return
		fi
		python3 -m venv .venv
		touch requirements.txt
		echo "source .venv/bin/activate" >.envrc
		direnv allow .
		_info "pyvenv を作成しました"
		_warn ".gitignore に .venv/ を追加してください。"
		;;
	"load")
		if [[ ! -d "${root}/.venv" ]]; then
			_error "このディレクトリーでは pyvenv init されていません！"
			return
		fi
		pip install -r requirements.txt
		_info "pyvenv をロードしました"
		;;
	"save")
		if [[ ! -d "${root}/.venv" ]]; then
			_error "このディレクトリーでは pyvenv init されていません！"
			return
		fi
		pip freeze >requirements.txt
		_info "pyvenv をセーブしました"
		;;
	*)
		_error "init or load or save"
		;;
	esac
}

function venv {
	if [ $# -lt 2 ]; then
		cat <<EOF
$(basename "${0}") is a venv tool...

Usage:
    $(basename "${0}") [language] [action]

Example:
    $(basename "${0}") python init 
    $(basename "${0}") python load
    $(basename "${0}") python save
(or)
    pyvenv init(load save)

Languages:
    - python
EOF
		return
	fi
	if [[ $2 == "init" || $2 == "load" || $2 == "save" ]]; then
		case "$1" in
		"python")
			pyvenv "$2"
			;;
		*)
			_error "\"$1\" language are not supported"
			;;
		esac
	else
		_error "action not found: $2"
		return
	fi
}

# shellcheck disable=2034,2152
function _venv() {
	local context curcontext=$curcontext state line
	declare -A opt_args
	local ret=1

	_arguments -C \
		'(-h --help)'{-h,--help}'[show help]' \
		'(-v --version)'{-v,--version}'[print the version]' \
		'1: :__venv_languasges' \
		'*:: :->args' &&
		ret=0

	case $state in
	args)
		_arguments -C \
			'1: :__venv_actions' &&
			ret=0
		;;
	esac

	return ret
}

__venv_languasges() {
	local -a _c
	_c=(
		'python:"python3 -m venv venv"'
	)

	_describe -t languages Languages _c
}

__venv_actions() {
	local -a _c
	_c=(
		'init:Init venv'
		'save:Save venv'
		'load:Load venv'
	)

	_describe -t actions Actions _c
}

compdef _venv venv
compdef __venv_actions pyvenv
