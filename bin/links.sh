#!/usr/bin/env bash

script_root=$(cd "$(dirname "$0")" && pwd)
dotfiles_root=$(dirname "${script_root}")
. "${script_root}"/common.sh
require_password

if [ $# -ne 1 ]; then
	error "実行するには1個の引数が必要です。
	usage: [link | unlink]
	
	Options:
	  link: create symbole link
	  unlink: remove symbole link
	"
	exit 1
fi

case $1 in
"link")
	setup_start "symbole links"
	echo
	config="${dotfiles_root}/config"
	cd "${dotfiles_root}"/dotfiles || exit
	for linklist in "${config}/linklist.Vim.txt" "${config}/linklist.Unix.txt" "${config}/linklist.$(uname).txt"; do
		[ ! -r "${linklist}" ] && continue

		__remove_linklist_comment "$linklist" | while read -r target link; do
			# ~ や環境変数を展開
			target=$(eval echo "${PWD}/${target}")
			link=$(eval echo "${link}")
			# シンボリックリンクを作成
			__mkdir "$(dirname "${link}")"
			__ln "${target}" "${link}"
		done
	done
	echo
	setup_end "symbole links"
	;;
"unlink")
	setup_start "remove symbole links"
	echo
	config="${dotfiles_root}/config"
	cd "${dotfiles_root}"/dotfiles || exit
	for linklist in "${config}/linklist.Vim.txt" "${config}/linklist.Unix.txt" "${config}/linklist.$(uname).txt"; do
		[ ! -r "${linklist}" ] && continue
		__remove_linklist_comment "$linklist" | while read -r target link; do
			# ~ や環境変数を展開
			link=$(eval echo "${link}")
			# シンボリックリンクを作成
			__unlink "${link}"
		done
	done
	echo
	setup_end "remove symbole links"
	;;
*)
	error "$1 の option はありません!
	usage: [link | unlink]
	
	Options:
	  link: create symbole link
	  unlink: remove symbole link
	"
	exit 1
	;;
esac
