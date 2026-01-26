vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

---@class TabOpt
---@field width integer
---@field expandtab false? (default true)

---@type table<string, TabOpt>
local tab = {
  rust = {
    width = 4,
  },
  make = {
    width = 8,
    expandtab = false,
  },
  just = {
    width = 4,
  },
  dosbatch = {
    width = 4,
  },
}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("mori_auto_tabset_per_filetype", { clear = true }),
  callback = function(event)
    local opt = tab[vim.bo[event.buf].filetype]
    if opt == nil then
      return
    end
    vim.bo[event.buf].tabstop = opt.width
    vim.bo[event.buf].softtabstop = opt.width
    vim.bo[event.buf].shiftwidth = opt.width
    if opt.expandtab ~= nil then
      vim.bo[event.buf].expandtab = opt.expandtab
    end
  end,
})
