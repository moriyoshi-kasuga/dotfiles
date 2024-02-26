return {
  -- installed colorschemes
  {
    "craftzdog/solarized-osaka.nvim",
  },
  {
    "LunarVim/lunar.nvim",
  },
  {
    "AstroNvim/astrotheme",
    config = function()
      require("astrotheme").setup({})
    end,
  },
  -- colorscheme settings
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
