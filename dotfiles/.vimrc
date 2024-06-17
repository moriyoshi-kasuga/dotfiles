" vimrc に以下のように追記
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set undodir=~/.vimundo
set undofile
set noswapfile
set nobackup
set updatetime=300
set signcolumn=yes
let mapleader=" "
nnoremap j gj
nnoremap k gk
syntax enable
autocmd Filetype xml if getfsize(@%) > 1000000 | setlocal syntax=OFF | endif

set nobackup
set nowritebackup

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト
set laststatus=2
"ファイルフォーマット
set fileformat=unix
"ビープ音を消す
set belloff=all
"スクロール時に一番下までカーソルが移動しない
set scrolloff=5

nnoremap <silent><leader>h :<C-u>set nohlsearch!<CR>
set number " 行番号を表示
set relativenumber " 相対行番号を表示
set cursorline " カーソルラインをハイライト
set background=dark

" 行が折り返し表示されていた場合、行単位ではなく表示行単位でカーソルを移動する

" バックスペースキーの有効化
set backspace=indent,eol,start

set showmatch " 括弧の対応関係を一瞬表示する
source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する
set matchpairs& matchpairs+=<:>
set matchtime=3
set lazyredraw
set ttyfast
set expandtab

set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数

if &term =~ "tmux"
    let &t_ti .= "\e[?2004h"
    let &t_te .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
    cnoremap <special> <Esc>[200~ <nop>
    cnoremap <special> <Esc>[201~ <nop>
endif

set expandtab " タブ入力を複数の空白入力に置き換える
set tabstop=4 " 画面上でタブ文字が占める幅
set shiftwidth=4 " smartindentで増減する幅
set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
autocmd Filetype c setlocal ts=2 sw=2
autocmd Filetype cs setlocal ts=2 sw=2
autocmd Filetype cpp setlocal ts=2 sw=2
autocmd Filetype css setlocal ts=2 sw=2
autocmd Filetype scss setlocal ts=2 sw=2
autocmd Filetype markdown setlocal ts=2 sw=2
autocmd Filetype vim setlocal ts=2 sw=2
autocmd Filetype javascript setlocal ts=2 sw=2
autocmd Filetype typescript setlocal ts=2 sw=2
autocmd Filetype javascriptreact setlocal ts=2 sw=2
autocmd Filetype typescriptreact setlocal ts=2 sw=2
autocmd Filetype json setlocal ts=2 sw=2
autocmd Filetype jsonc setlocal ts=2 sw=2
autocmd Filetype html setlocal ts=2 sw=2
autocmd Filetype htmldjango setlocal ts=2 sw=2
autocmd Filetype lua setlocal ts=2 sw=2
autocmd Filetype yaml setlocal ts=2 sw=2
autocmd Filetype yml setlocal ts=2 sw=2
autocmd Filetype java setlocal ts=2 sw=2
autocmd Filetype class setlocal ts=2 sw=2
autocmd Filetype make setlocal ts=8 sw=8 noexpandtab

filetype plugin on
filetype plugin indent on
" ファイルツリーの表示形式、1にするとls -laのような表示になります
let g:netrw_liststyle=1
" ヘッダを非表示にする
let g:netrw_banner=0
" サイズを(K,M,G)で表示する
let g:netrw_sizestyle="H"
" 日付フォーマットを yyyy/mm/dd(曜日) hh:mm:ss で表示する
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
" プレビューウィンドウを垂直分割で表示する
let g:netrw_preview=1

" coc
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"


inoremap <silent><expr> <C-k> coc#refresh()


" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" Remap keys for applying code actions at the cursor position
nmap ga  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap gA  <Plug>(coc-codeaction-source)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>l  :<C-u>CocList<cr>

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

command! -nargs=0 Format :call CocActionAsync('format')
nnoremap <leader>r :Format<cr>
nnoremap <leader>i :CocCommand document.toggleInlayHint<cr>
nnoremap <leader>cr <Plug>(coc-rename)

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

autocmd InsertEnter,InsertLeave * set cul!

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
