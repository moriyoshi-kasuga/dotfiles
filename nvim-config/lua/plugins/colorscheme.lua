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
      integrations = {
        blink = true,
        flash = true,
        grug_far = true,
        mini = true,
        fzf = true,
        nvim_surround = true,
        blink_cmp = true,
        neogit = true,
        render_markdown = true,
        octo = true,
        snacks = {
          enabled = true,
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
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
}
