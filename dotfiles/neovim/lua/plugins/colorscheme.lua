return {
  "catppuccin/nvim",
  lazy = true,
  name = "catppuccin",
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
      noice = true,
      notify = true,
      snacks = true,
      treesitter_context = true,
    },
  },
  init = function()
    vim.cmd("colorscheme catppuccin-mocha")
  end
}
