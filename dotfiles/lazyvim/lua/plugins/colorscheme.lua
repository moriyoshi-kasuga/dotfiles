return {
  -- installed colorschemes
  {
    "rafi/theme-loader.nvim",
    lazy = false,
    priority = 999,
    opts = {},
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function() end,
    },
  },
  { "rebelot/kanagawa.nvim", lazy = false },
}
