return {
  "woosaaahh/sj.nvim",
  lazy = false,
  config = function()
    local sj = require("sj")
    sj.setup()
    vim.keymap.set("n", "s", sj.run)
  end,
}
