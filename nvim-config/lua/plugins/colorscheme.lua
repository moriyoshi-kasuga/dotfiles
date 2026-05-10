return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  ---@type CatppuccinOptions
  opts = {
    flavour = "mocha",
    transparent_background = true,
    float = {
      transparent = true,
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
    custom_highlights = function(colors)
      return {
        RenderMarkdownCode = { bg = colors.base },
        RenderMarkdownCodeInfo = { bg = colors.base },
        RenderMarkdownCodeBorder = { bg = colors.base },
      }
    end,
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
    vim.cmd("colorscheme catppuccin-mocha")
  end,
}
