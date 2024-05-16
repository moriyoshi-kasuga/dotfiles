return {
  -- formatters
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        djlint = {
          prepend_args = { "--indent", "2" },
        },
        black = {
          prepend_args = { "--fast" },
        },
        flake8 = {
          prepend_args = { "--max-line-length", "88" },
        },
      },
      formatters_by_ft = {
        ["htmldjango"] = { "djlint" },
      },
    },
  },
}
