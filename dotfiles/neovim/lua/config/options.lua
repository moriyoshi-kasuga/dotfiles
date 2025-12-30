local is_simple_mode = require("config.util").is_in_simple_mode()

vim.opt.backup = true
local backup_dir = vim.fn.expand(vim.fn.stdpath("cache") .. "/.vim_backup")
if vim.fn.isdirectory(backup_dir) == 0 then
  vim.fn.mkdir(backup_dir, "p")
end
vim.opt.backupdir = backup_dir
vim.opt.swapfile = false
vim.opt.writebackup = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.mouse = ""
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
vim.opt.updatetime = 200
vim.opt.timeoutlen = 1000
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.pumheight = 10
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

if is_simple_mode then
  -- Simple mode: disable folding completely
  vim.opt.foldmethod = "manual"
  vim.opt.foldenable = false
else
  -- Full mode: treesitter-based folding
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.opt.foldenable = false
  vim.opt.foldlevel = 99
end

vim.opt.splitright = true
vim.opt.splitbelow = true

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

if is_simple_mode then
  -- Simple mode: minimal history and no persistent state
  vim.opt.shada = "!,'10,h" -- Minimal marks (10 files) and disable hlsearch on load
  vim.opt.undofile = false
  vim.opt.undolevels = 100
  vim.opt.jumpoptions = "stack" -- Limit jumplist behavior
else
  -- Full mode: normal history settings
  vim.opt.shada = "!,'50,<10,s5,h"
  vim.opt.undofile = true
  vim.opt.undolevels = 10000
end

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

-- hide cmd
vim.opt.showcmd = false
vim.opt.cmdheight = 0

-- hide statusline
vim.opt.laststatus = 0
vim.opt.fillchars = {
  stl = "─",
  stlnc = "─",
}
vim.opt.statusline = "─"

-- smooth bg and fg on statusline
local function update_statusline_colors()
  local bg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg#")
  local fg = vim.fn.synIDattr(vim.fn.hlID("VertSplit"), "fg#")
  if bg == "" then
    bg = "NONE"
  end
  if fg == "" then
    fg = "None"
  end
  vim.cmd("hi StatusLine ctermbg=NONE guibg=" .. bg .. " ctermfg=NONE guifg=" .. fg)
  vim.cmd("hi StatuslineNC ctermbg=NONE guibg=" .. bg .. " ctermfg=NONE guifg=" .. fg)
end

-- Update on initial load
update_statusline_colors()

-- Update when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("mori_statusline_colors", { clear = true }),
  callback = update_statusline_colors,
})
