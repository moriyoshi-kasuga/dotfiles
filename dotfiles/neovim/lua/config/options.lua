vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand(vim.fn.stdpath("cache") .. "/.vim_backup")
vim.opt.swapfile = false
vim.opt.writebackup = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.mouse = ""

vim.opt.laststatus = 3
vim.opt.splitkeep = "cursor"

-- disable nvim intro
vim.opt.shortmess:append("sI")

vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.virtualedit = "block"
vim.opt.visualbell = false
vim.opt.errorbells = false
vim.opt.showmatch = false
vim.opt.showcmd = true
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.pumheight = 10
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
vim.opt.foldlevel = 99

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.fenc = "utf-8"
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.nrformats:remove({ "unsigned", "octal" })

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wrapscan = true
vim.opt.wildmode = { list = "longest" }

vim.opt.shada = "!,'50,<10,s5,h"

vim.opt.undofile = true
vim.opt.undolevels = 10000

-- コマンドライン補完
vim.opt.wildignorecase = true

-- セッション保存項目の最適化
vim.opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp"

vim.g.clipboard = vim.env.SSH_CONNECTION and "" or "pbcopy"
vim.g.editorconfig = true

-- disable some default providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

local treesitter_grammars = vim.env.TREESITTER_GRAMMARS
if treesitter_grammars then
  vim.opt.runtimepath:append(treesitter_grammars)
end

-- Disable loading of built-in markdown syntax (use treesitter instead)
vim.g.markdown_fenced_languages = {}
vim.g.markdown_recommended_style = 0
vim.g.markdown_syntax_conceal = 0
