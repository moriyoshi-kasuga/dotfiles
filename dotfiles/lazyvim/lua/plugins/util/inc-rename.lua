return {
  "smjonas/inc-rename.nvim",
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("inc_rename").setup({})
    vim.keymap.set("n", "gR", ":IncRename ", { desc = "Inc Rename" })
  end,
}
