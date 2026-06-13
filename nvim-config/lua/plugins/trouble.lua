if require("config.util").is_in_simple_mode() then
  return {}
end

return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { focus = true },
    -- stylua: ignore
    keys = {
      -- diagnostics
      { ",x", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { ",X", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      -- symbols / LSP
      { "gsa", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "gR", "<cmd>Trouble lsp<cr>", desc = "LSP Definitions/References (Trouble)" },
      -- list
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      -- todo-comments.nvim
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    },
  },
}
