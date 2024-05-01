return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      javascript = { { "prettierd", "prettier" } },
      typescript = { { "prettierd", "prettier" } },
      javascriptreact = { { "prettierd", "prettier" } },
      typescriptreact = { { "prettierd", "prettier" } },
      svelte = { { "prettierd", "prettier" } },
      graphql = { { "prettierd", "prettier" } },
      iquid = { { "prettierd", "prettier" } },
      lua = { "stylua" },
    },
  },
  lazy = true,
  config = function(_, opts)
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = opts.formatters_by_ft,
      format_on_save = false,
    })

  end,
  keys = {
    {
      "<leader>r",
      function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end,
      desc = "Format file or range",
    },
  },
}
