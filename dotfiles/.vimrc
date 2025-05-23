" highlight
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" option
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast

set tabstop=4
set shiftwidth=0

set splitbelow
set termwinsize=15x0

set number
set relativenumber
set hlsearch
set ignorecase
set smartcase
set expandtab
set termguicolors

let g:netrw_banner=0
let g:netrw_bufsettings = 'noma nomod relativenumber nobl nowrap ro'

" keymap
let mapleader = "\<space>"
nnoremap <leader>h :set nohlsearch<CR>
nnoremap j gj
nnoremap k gk

" Plugins
let s:jetpack_dir = expand('~/.vim/pack/jetpack/start/vim-jetpack/plugin/jetpack.vim')
let s:jetpack_url = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'

if !filereadable(s:jetpack_dir)
  call system(printf('curl -fsSLo %s --create-dirs %s', s:jetpack_dir, s:jetpack_url))
endif

packadd vim-jetpack
call jetpack#begin()

Jetpack 'tani/vim-jetpack'
Jetpack 'tpope/vim-surround'
Jetpack 'tpope/vim-commentary'

Jetpack 'catppuccin/vim', { 'as': 'catppuccin' }
colorscheme catppuccin_macchiato

Jetpack 'jdhao/better-escape.vim'
let g:better_escape_shortcut = 'jk'

call jetpack#end()
