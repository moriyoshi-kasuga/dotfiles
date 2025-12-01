-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.editorconfig = true
vim.g.autoformat = false
vim.g.snacks_animate = false
vim.g.lazyvim_picker = "snacks"
vim.g.lazyvim_cmp = "blink.cmp"
vim.g.ai_cmp = false

vim.opt.clipboard = ""
vim.opt.signcolumn = "no"
vim.opt.numberwidth = 3
vim.opt.mouse = ""
vim.opt.list = false
vim.opt.laststatus = 3

-- Optimize shada file to reduce startup time
-- !: Save global variables
-- '50: Save marks for last 50 files (reduced from 100)
-- <10: Save max 10 lines for each register (reduced from 50)
-- s5: Skip items larger than 5KB (reduced from 10KB)
-- h: Disable hlsearch on start
vim.opt.shada = "!,'50,<10,s5,h"

vim.cmd([[
 se splitkeep=cursor
]])

vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"

vim.g.clipboard = "pbcopy"

-- In ssh sessions, use OSC52 for clipboard support
-- vim.g.clipboard = "osc52"
