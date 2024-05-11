#!/usr/bin/env bash

. "${script_root}"/color.sh

# 0 debug,1 info,2 notice,3 warn,4 error
LOGGER_LEVEL=0
LOGGER_PREFIX=("DEBUG" "INFO" "NOTICE" "WARN" "ERROR")
LOGGER_COLOR=("${BLACK}${WHITE_BG}" "${WHITE}" "${BLUE}" "${YELLOW}" "${RED_B}")

function log() {
	echo "${YELLOW}[$(date)]$1[$2] $3${NC}"
}

function logger() {
	local level="$1"
	if test "${level}" -lt "${LOGGER_LEVEL}"; then
		return
	fi
	log "${LOGGER_COLOR[$level]}" "${LOGGER_PREFIX[$level]}" "$2"
}

function debug() {
	logger 1 "$1"
}

function info() {
	logger 2 "$1"
}

function notice() {
	logger 3 "$1"
}

function warn() {
	logger 4 "$1"
}

function error() {
	logger 5 "$1"
}

function setup_start() {
	log "${PURPLE}" "SETUP ↘" "★ Start setup ${PURPLE_U}$1${PURPLE}."
}

function setup_end() {
	log "${PURPLE}" "SETUP ↗" "★ End setup ${PURPLE_U}$1${PURPLE}."
}

function install_exist() {
	log "${BLUE}" "INSTALL ⌾" "✔︎ Already installed ${BLUE_U}$1${BLUE}."
}

function install_start() {
	log "${BLUE}" "INSTALL ↘" "▷ Installing  ${BLUE_U}$1${BLUE}..."
}

function install_end() {
	log "${BLUE}" "INSTALL ↗" "✔︎ End install ${BLUE_U}$1${BLUE}."
}

function load_brew() {
	if type "brew" >/dev/null 2>&1; then
		return 0
	fi
	test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
	test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	test -d /opt/homebrew && eval "$(/opt/homebrew/bin/brew shellenv)"
	if ! type "brew" >/dev/null 2>&1; then
		error "Please ${RED_U}make brew (or make init)"
	fi
}

function require_password() {
	if [[ -z "$CI" ]]; then
		sudo -v
	fi
}

# シンボリックリンクを作成
function __ln() { (
	# リンクがすでに存在すれば削除
	[ -L "$2" ] && unlink "$2"

	# シンボリックリンクを作成
	ln -s "$1" "$2" && info "ln: $1 -> $2" >&2
); }

# シンボリックリンクを削除
function __unlink() { (
	unlink "$1" && info "unlink: \"$1\""
); }

# ディレクトリを再帰的に作成
function __mkdir() { (
	[ ! -e "$1" ] && mkdir -p "$1" && info "mkdir: \"$1\"" >&2
); }

# linklist.txtのコメントを削除
function __remove_linklist_comment() { (
	# '#'以降と空行を削除
	sed -e 's/\s*#.*//' \
		-e '/^\s*$/d' \
		"$1"
); }
