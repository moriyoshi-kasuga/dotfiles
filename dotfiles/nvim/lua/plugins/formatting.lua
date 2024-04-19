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
    }
  },
  config = function(opts)
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = opts.formatters_by_ft,
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    -- TODO: この動画をみて conform nvim と nvim lint の再設定をする https://www.youtube.com/watch?v=ybUE4D80XSk
    vim.keymap.set({ "n", "v" }, "<leader>r", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
