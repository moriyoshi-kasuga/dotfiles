return {
  -- installed colorschemes
  {
    "craftzdog/solarized-osaka.nvim",
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("tokyonight").setup({
        -- use the night style
        style = "moon",
        -- disable italic for functions
        styles = {
          functions = {},
        },
        sidebars = { "qf", "vista_kind", "terminal", "packer" },
        -- Change the "hint" color to the "orange" color, and make the "error" color bright red
        on_colors = function(colors)
          colors.hint = colors.orange
          colors.error = "#ff0000"
        end,
      })
    end,
  },
  -- colorscheme settings
  {
    "rafi/theme-loader.nvim",
    lazy = false,
    priority = 999,
    opts = {},
  },
}