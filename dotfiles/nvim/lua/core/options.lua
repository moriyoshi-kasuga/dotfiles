vim.g.autoformat = false -- disable auto format
vim.g["qs_highlight_on_keys"] = { "f", "F", "t", "T" }

local opt = vim.opt


opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.scrolloff = 4 -- Lines of context
opt.sidescrolloff = 8 -- Columns of context
opt.showmode = false -- Dont show mode since we have a statusline
opt.shiftround = true -- Round indent
opt.confirm = false -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.number = true
opt.relativenumber = true
opt.title = true
opt.cmdheight = 0
opt.termguicolors = true
opt.updatetime = 100
opt.textwidth = 0
opt.signcolumn = "auto"
opt.background = "dark"
-- tab時の見かけのスペース数
opt.tabstop = 2
-- 自動的に挿入される量
opt.shiftwidth = 2
-- 検索時の強調表示
opt.inccommand = "split"
-- Windowsでパスの区切り文字をスラッシュで扱う
-- 対応する括弧を強調表示
opt.showmatch = true
opt.matchtime = 1
opt.swapfile = false
opt.shadafile = "NONE"
opt.fileencoding = "utf-8"
opt.spelllang = "en_us"
opt.fileformats = { "unix", "dos", "mac" }
-- 検索系
-- 検索文字列が小文字の場合は大文字小文字を区別なく検索する
opt.ignorecase = true
-- 検索文字列に大文字が含まれている場合は区別して検索する
opt.smartcase = true
-- 検索文字列入力時に順次対象文字列にヒットさせる
opt.incsearch = true
-- 検索時に最後まで行ったら最初に戻る
opt.wrapscan = true
-- 検索語をハイライト非表示
opt.hlsearch = true
-- 括弧をハイライト表示
opt.showmatch = true
-- 括弧秒数を調整
opt.matchtime = 1
-- cmp 設定
opt.completeopt = { "menu", "menuone", "noselect" }
-- キーの待ち時間設定
opt.timeout = true
opt.timeoutlen = 1000
-- インデント
opt.autoindent = true
opt.smartindent = true
-- 改行時にtabをスペースに変換
-- (インサート時に(Ctrl+v)+tabでtab挿入)
opt.expandtab = true
--行の改行を防ぐ
opt.linebreak = true
-- 制御文字を表示
opt.list = false

-- ノーマルモードから出るまでの時間を短縮
opt.ttimeoutlen = 1
-- 仮想編集を有効
opt.virtualedit = "onemore"
-- -エラー時の音を画面表示に
opt.visualbell = true
opt.wildignore =
  ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**"
opt.fileencoding = "utf-8"
opt.termguicolors = true
-- undoの永続化
opt.undodir = vim.fn.stdpath("state")
opt.undofile = true
-- ファイル末尾の記号を消す
opt.fillchars:append("eob: ")
opt.helplang = { "ja", "en" }
opt.wrap = false
--fold
opt.fillchars = { fold = " " }
opt.foldmethod = "indent"
opt.foldenable = false
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0