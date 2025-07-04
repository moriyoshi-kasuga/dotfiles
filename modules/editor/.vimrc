" " highlight
" unlet! skip_defaults_vim
" source $VIMRUNTIME/defaults.vim

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

set mouse=
let g:netrw_banner=0
let g:netrw_bufsettings = 'noma nomod relativenumber nobl nowrap ro'

let mapleader = "\<space>"
nnoremap <leader>h :set nohlsearch<CR>
nnoremap j gj
nnoremap k gk
