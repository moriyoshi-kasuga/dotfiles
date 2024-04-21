vim.treesitter.start = (function(wrapped)
  return function(bufnr, lang)
    lang = lang or vim.fn.getbufvar(bufnr or "", "&filetype")
    pcall(wrapped, bufnr, lang)
  end
end)(vim.treesitter.start)

vim.loader.enable()
-- leaderキーをspaceに変更
vim.g.mapleader = " "
require("core.options")
require("core.lazy")
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("core.autocmd")
    require("core.keymap")
    local json = { json = true, jsonc = true, json5 = true }
    if json[vim.bo.filetype] then
      vim.opt_local.conceallevel = 0
    end
  end,
})
