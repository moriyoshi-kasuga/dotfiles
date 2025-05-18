-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.editorconfig = true
vim.g.autoformat = false
vim.g.snacks_animate = false
vim.g.lazyvim_picker = "fzf"
vim.g.lazyvim_cmp = "blink.cmp"
vim.g.ai_cmp = false

vim.opt.clipboard = ""
vim.opt.signcolumn = "no"
vim.opt.numberwidth = 3
vim.opt.mouse = ""
vim.opt.list = false
vim.opt.laststatus = 3
vim.cmd([[
 se splitkeep=cursor
]])
