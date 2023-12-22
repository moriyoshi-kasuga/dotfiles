-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false -- disable auto format
vim.g["qs_highlight_on_keys"] = { "f", "F", "t", "T" }
vim.opt.spelllang = "en,cjk"

vim.o.mouse = "" -- disable mouse

vim.opt.list = false
