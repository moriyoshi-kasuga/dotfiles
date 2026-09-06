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
    "TextCaseOpenTelescope",
    "TextCaseOpenTelescopeQuickChange",
    "TextCaseOpenTelescopeLSPChange",
    "TextCaseStartReplacingCommand",
  },
  event = "VeryLazy",
}
