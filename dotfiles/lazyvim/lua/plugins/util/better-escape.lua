return {
  "max397574/better-escape.nvim",
  event = { "LazyFile", "VeryLazy" },
  config = function()
    require("better_escape").setup()
  end,
}
