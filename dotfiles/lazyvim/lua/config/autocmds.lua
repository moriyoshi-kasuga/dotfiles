-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd([[
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
]])

local ac = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

-- next/prev heading on markdown
ac("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set({ "n", "x" }, "]#", [[/^#\+ .*<CR>]], { desc = "Next Heading", buffer = true })
    vim.keymap.set({ "n", "x" }, "[#", [[?^#\+ .*<CR>]], { desc = "Prev Heading", buffer = true })
  end,
})

-- Disable diagnostics in a .env file
ac("BufRead", {
  pattern = ".env",
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- Disable eslint on node_modules
ac({ "BufNewFile", "BufRead" }, {
  group = ag("DisableEslintOnNodeModules", { clear = true }),
  pattern = { "**/node_modules/**", "node_modules", "/node_modules/*" },
  callback = function()
    vim.diagnostic.disable(0)
  end,
})
