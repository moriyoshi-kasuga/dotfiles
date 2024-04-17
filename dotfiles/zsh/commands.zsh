### Custom commands

source "${HOME}/zsh/script/common.sh"
source "${HOME}/zsh/script/user.sh"
source "${HOME}/zsh/script/venv.sh"

zvm_after_init_commands+=('bindkey "^H" backward-delete-char')

for f in zvm_backward_kill_region zvm_yank zvm_change_surround_text_object zvm_vi_delete zvm_vi_change zvm_vi_change_eol; do
  eval "$(echo "_$f() {"; declare -f $f | tail -n +2)"
  eval "$f() { _$f; echo -en \$CUTBUFFER | pbcopy }"
done

for f in zvm_vi_replace_selection; do
  eval "$(echo "_$f() {"; declare -f $f | tail -n +2)"
  eval "$f() { CUTBUFFER=\$(pbpaste); _$f; echo -en \$CUTBUFFER | pbcopy }"
done

for f in zvm_vi_put_after zvm_vi_put_before; do
  eval "$(echo "_$f() {"; declare -f $f | tail -n +2)"
  eval "$f() { CUTBUFFER=\$(pbpaste); _$f; zvm_highlight clear }"
done
