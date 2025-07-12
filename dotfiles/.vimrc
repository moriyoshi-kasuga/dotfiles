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

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>wv :vsplit<CR>
nnoremap <leader>ws :split<CR>
nnoremap <leader>wo :only<CR>


" plugin

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END

nnoremap <leader>i :UndotreeToggle<CR>

nnoremap <leader><space> :Files<CR>
nnoremap <leader>g :GFiles<CR>

let g:yazi_replace_netrw = 1
