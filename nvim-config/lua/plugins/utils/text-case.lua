return {
  "johmsalas/text-case.nvim",
  config = function()
    require("textcase").setup({
      prefix = "gh",
    })
  end,
  keys = {
    { "gh", desc = "text case" },
  },
  cmd = {
    "Subs",
    "TextCaseStartReplacingCommand",
  },
  event = "VeryLazy",
}
