vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand(vim.fn.stdpath("cache") .. "/.vim_backup")
vim.opt.swapfile = false
vim.opt.writebackup = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.mouse = "a"

vim.opt.laststatus = 3
vim.opt.splitkeep = "screen"

-- disable nvim intro
vim.opt.shortmess:append "sI"

vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.virtualedit = "onemore"
vim.opt.visualbell = false
vim.opt.errorbells = false
vim.opt.showmatch = true
vim.opt.showcmd = true

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

vim.opt.undofile = true
vim.opt.undolevels = 10000

vim.opt.whichwrap:append "<>[]hl"

vim.g.clipboard = vim.env.SSH_CONNECTION and "" or "pbcopy"

-- disable some default providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
