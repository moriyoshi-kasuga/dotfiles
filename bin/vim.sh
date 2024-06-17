#!/usr/bin/env bash

script_root=$(cd "$(dirname "$0")" && pwd)
dotfiles_root=$(dirname "${script_root}")
. "${script_root}"/common.sh
require_password

setup_start "Vim"
echo
if type "Vim" >/dev/null 2>&1; then
	install_exist "Vim"
else
	install_start "Vim"
	sudo apt install vim >/dev/null 2>&1
	install_end "Vim"
fi

echo

setup_start "vim symbole links"
echo
config="${dotfiles_root}/config"
cd "${dotfiles_root}"/dotfiles || exit
linklist="${config}/linklist.Vim.txt"

__remove_linklist_comment "$linklist" | while read -r target link; do
	# ~ や環境変数を展開
	target=$(eval echo "${PWD}/${target}")
	link=$(eval echo "${link}")
	# シンボリックリンクを作成
	__mkdir "$(dirname "${link}")"
	__ln "${target}" "${link}"
done
echo
setup_end "vim symbole links"

echo
setup_end "Vim"
