return {
  {
    {
      "MeanderingProgrammer/render-markdown.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
      ft = "markdown",
      ---@module 'render-markdown'
      opts = {
        render_modes = true,
        sign = {
          enabled = false,
        },
        heading = {
          width = "block",
          sign = false,
          icons = {},
        },
        code = {
          sign = false,
          width = "block",
          border = "thin",
          right_pad = 1,
        },
        checkbox = {
          enabled = false,
        },
        html = {
          comment = {
            conceal = false,
          },
        },
      },
    },
    { "jannis-baum/vivify.vim", ft = "markdown" },
  },
}
