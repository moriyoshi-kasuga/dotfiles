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
  { "catppuccin/nvim", lazy = false },
  { "rebelot/kanagawa.nvim", lazy = false },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
