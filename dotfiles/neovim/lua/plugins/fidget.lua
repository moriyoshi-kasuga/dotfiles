return {
  "j-hui/fidget.nvim",
  event = "UIEnter",
  opts = {},
  config = function(_, opts)
    require("fidget").setup(opts)
    vim.notify = require("fidget.notification").notify
  end,
}
