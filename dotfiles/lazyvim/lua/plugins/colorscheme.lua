return {
  -- installed colorschemes
  {
    "craftzdog/solarized-osaka.nvim",
  },
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
}
