-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", " [^ ]*")
      vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
    end)
  end,
})
