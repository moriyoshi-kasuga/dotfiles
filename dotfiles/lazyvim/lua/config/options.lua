-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false -- disable auto format
vim.g["qs_highlight_on_keys"] = { "f", "F", "t", "T" }
vim.opt.spelllang = "en,cjk"

vim.cmd([[
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
]])

vim.o.clipboard = ""

vim.o.mouse = "" -- disable mouse

vim.opt.list = false

vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})
