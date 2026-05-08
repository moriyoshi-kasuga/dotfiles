vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

---@class TabOpt
---@field extensions string[]
---@field width integer
---@field expandtab false? (default true)

---@type TabOpt[]
local tab = {
  {
    extensions = {
      "rust",
      "python",
      "swift",
      "c",
      "cpp",
      "cs",
      "php",
      "haskell",
      "elixir",
      "zig",
      "nim",
      "just",
      "dosbatch",
      "sql",
    },
    width = 4,
  },
  { extensions = { "go" }, width = 4, expandtab = false },
  { extensions = { "make" }, width = 8, expandtab = false },
}

local lookup = {}
for _, opt in ipairs(tab) do
  for _, ext in ipairs(opt.extensions) do
    lookup[ext] = opt
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("mori_auto_tabset_per_filetype", { clear = true }),
  callback = function(event)
    local opt = lookup[vim.bo[event.buf].filetype]
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
