return {
  {
    {
      "MeanderingProgrammer/render-markdown.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
      ft = { "markdown" },
      ---@module 'render-markdown'
      opts = {
        render_modes = true,
        heading = {
          width = "block",
          sign = false,
          icons = {},
        },
        code = {
          sign = false,
          width = "block",
          right_pad = 1,
        },
        checkbox = {
          enabled = false,
        },
      },
    },
    {
      "brianhuster/live-preview.nvim",
      cmd = "LivePreview",
      dependencies = { "ibhagwan/fzf-lua" },
    },
  },
}
