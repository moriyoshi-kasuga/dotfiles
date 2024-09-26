return {
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>r",
        function()
          LazyVim.format({ force = true })
        end,
        desc = "Format buffer",
      },
    },
  },
}
