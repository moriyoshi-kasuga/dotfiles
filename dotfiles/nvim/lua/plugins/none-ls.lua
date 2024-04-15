return {
  {
    "nvimtools/none-ls.nvim",
    config = function(opts)
      local nls = require("null-ls")

      opts.sources = vim.list_extend(opts.sources or {}, {
        -- NOTE : formatting
        nls.builtins.formatting.prettierd,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.shfmt,
        --TODO : https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md?plain=1#L182
        nls.builtins.formatting.black.with {
          extra_args = { "--fast" }
        },
        nls.builtins.formatting.djlint.with {
          extra_args = { "--indent", "2" }
        },
        -- NOTE : diagnostics
      })
    end,
  },
}
