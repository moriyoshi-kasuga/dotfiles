-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd([[
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
]])

local ac = vim.api.nvim_create_autocmd

-- next/prev heading on markdown
ac("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set({ "n", "x" }, "]#", [[/^#\+ .*<CR>]], { desc = "Next Heading", buffer = true })
    vim.keymap.set({ "n", "x" }, "[#", [[?^#\+ .*<CR>]], { desc = "Prev Heading", buffer = true })
  end,
})

ac("FileType", {
  pattern = { "markdown", "txt" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

ac("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", " [^ ]*")
      vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
    end)
  end,
})
