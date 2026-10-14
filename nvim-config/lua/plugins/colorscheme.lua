return {
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    ---@type CatppuccinOptions
    opts = {
      -- Nix (modules/style/catppuccin.nix) が wrapper の環境変数で渡す
      flavour = vim.env.CATPPUCCIN_FLAVOR or "macchiato",
      compile = { enabled = true },
      transparent_background = false,
      float = {
        transparent = false,
        solid = false,
      },
      term_colors = true,
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd("colorscheme catppuccin-" .. opts.flavour)
    end,
  },
  {
    "folke/tokyonight.nvim",
    -- loaded by lazy.nvim when picked with :colorscheme
    lazy = true,
    opts = {},
  },
  {
    "rebelot/kanagawa.nvim",
    -- loaded by lazy.nvim when picked with :colorscheme
    lazy = true,
    opts = {},
  },
}
