return {
  {
    "mrcjkb/rustaceanvim",
    version = "^7",
    ft = { "rust" },
    opts = {
      tools = {
        hover_actions = {
          replace_builtin_hover = false,
        },
      },
      server = {
        on_attach = function(_, bufnr)
          ---@param lhs string
          ---@param rhs string|function
          ---@param desc string
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc, buffer = bufnr })
          end
          map("<leader>cx", "<cmd>RustLsp openDocs<cr>", "Open docs")
          map("<leader>cm", "<cmd>RustLsp rebuildProcMacros<cr>", "Rebuild ProcMacros")
          map("<leader>ce", "<cmd>RustLsp explainError<cr>", "Explain Error")
          map("<leader>co", "<cmd>RustLsp expandMacro<cr>", "Expand Macro")
          map("<leader>cp", "<cmd>RustLsp parentModule<cr>", "Parent Module")
        end,
        default_settings = {
          ["rust-analyzer"] = {
            completion = {
              snippets = {
                custom = {
                  Arrow = {
                    postfix = "arrow",
                    body = "(*${receiver})",
                    description = "like c arrow useful snippets",
                    scope = "expr",
                  },
                },
              },
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
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

            -- clippyは非常に重いため、cargo checkで代用する
            check = {
              command = "check",
            },
            checkOnSave = true,
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
              watcher = "client",
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local is_dioxus_project = vim.fs.root(0, { "Dioxus.toml" }) ~= nil
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      if is_dioxus_project then
        opts.formatters_by_ft.rust = { "dioxus", lsp_format = "first" }
      end
    end,
  },

  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}
