return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  ---@type CatppuccinOptions
  opts = {
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
      treesitter_context = true,
      nvim_surround = true,
      blink_cmp = true,
      diffview = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd("colorscheme catppuccin-mocha")
  end,
}
