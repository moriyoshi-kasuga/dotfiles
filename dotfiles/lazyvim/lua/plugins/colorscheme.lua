return {
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
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "solarized-osaka",
      colorscheme = "lunar",
      -- colorscheme = "catppuccin-macchiato",
      -- colorscheme = "astrodark",
    },
  },
}
