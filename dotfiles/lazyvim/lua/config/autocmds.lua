-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd([[
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
]])

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

local function del_lazyvim_auto_cmd(name)
  local cmds = vim.api.nvim_get_autocmds({
    group = augroup(name),
  })

  for _, value in ipairs(cmds) do
    if value.id then
      vim.api.nvim_del_autocmd(value.id)
    end
  end
end

del_lazyvim_auto_cmd("close_with_q")
del_lazyvim_auto_cmd("wrap_spell")

-- next/prev heading on markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set({ "n", "x" }, "]#", [[/^#\+ .*<CR>]], { desc = "Next Heading", buffer = true })
    vim.keymap.set({ "n", "x" }, "[#", [[?^#\+ .*<CR>]], { desc = "Prev Heading", buffer = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", " [^ ]*")
      vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
    end)
  end,
})
