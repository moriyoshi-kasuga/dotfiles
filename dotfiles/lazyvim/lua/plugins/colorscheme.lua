return {
  -- installed colorschemes
  {
    "rafi/theme-loader.nvim",
    priority = 999,
    opts = {},
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function() end,
    },
  },
  { "rebelot/kanagawa.nvim" },
}
