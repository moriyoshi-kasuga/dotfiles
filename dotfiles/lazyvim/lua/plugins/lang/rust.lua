return {
  {
    "mrcjkb/rustaceanvim",
    opts = {
      tools = {
        hover_actions = {
          replace_builtin_hover = false,
        },
      },
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set(
            "n",
            "<leader>cx",
            "<cmd>RustLsp openDocs<cr>",
            { silent = true, desc = "Open docs", buffer = bufnr }
          )
          vim.keymap.set(
            "n",
            "<leader>cm",
            "<cmd>RustLsp rebuildProcMacros<cr>",
            { silent = true, desc = "Rebuild ProcMacros", buffer = bufnr }
          )
          vim.keymap.set(
            "n",
            "<leader>ce",
            "<cmd>RustLsp explainError<cr>",
            { silent = true, desc = "Explain Error", buffer = bufnr }
          )
          vim.keymap.set(
            "n",
            "<leader>co",
            "<cmd>RustLsp expandMacro<cr>",
            { silent = true, desc = "Expand Macro", buffer = bufnr }
          )
          vim.keymap.set(
            "n",
            "<leader>ct",
            "<cmd>RustLsp parentModule<cr>",
            { silent = true, desc = "Goto Parent Module", buffer = bufnr }
          )
        end,
        default_settings = {
          ["rust-analyzer"] = {
            diagnostics = {
              disabled = { "macro-error", "proc-macro-disabled" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["tauri_macros"] = { "generate_context" },
                ["sqlx_macros"] = { "test" },
                ["tokio_macros"] = { "test", "main" },
              },
            },
            files = {
              excludeDirs = {
                "**/.git",
                "**/node_modules",
                "**/target",
                "**/vendor",
                "**/.svelte-kit",
                "**/build",
              },
              exclude = {
                "**/.git",
                "**/node_modules",
                "**/target",
                "**/vendor",
                "**/.svelte-kit",
                "**/build",
              },
            },
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local is_dioxus_project = vim.fs.root(0, { "Dioxus.toml" }) ~= nil
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      if is_dioxus_project then
        opts.formatters_by_ft.rust = { "dioxus", "rustfmt", lsp_format = "fallback" }
      end
    end,
  },
}
