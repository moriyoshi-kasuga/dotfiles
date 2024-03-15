#!/usr/bin/env bash

_log() {
	local ESC
	ESC=$(printf '\033')
	echo "${ESC}[$1m$2:${ESC}[m ${*:3}"
}
_error() {
	_log "31" "Error" "$@"
}

_warn() {
	_log "33" "Warn" "$@"
}

_info() {
	_log "32" "Info" "$@"
}
