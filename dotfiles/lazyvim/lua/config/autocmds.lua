-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust" },
  group = vim.api.nvim_create_augroup("disable_completion_single_quote_on_rust", { clear = true }),
  callback = function()
    LazyVim.on_load("mini.pairs", function()
      vim.keymap.set("i", "'", "'", { buffer = true })
    end)
  end,
})
