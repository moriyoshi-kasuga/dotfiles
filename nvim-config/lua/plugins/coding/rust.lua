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
          map("<leader>cJ", "<cmd>RustLsp joinLines<cr>", "Join Lines")
          map("<leader>cH", "<cmd>RustLsp hover actions<cr>", "Hover Actions")
          map("gsr", "<cmd>RustLsp relatedDiagnostics<cr>", "Related Diagnostics")
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
              -- 無効にすると型エラーなどがでる
              -- ignored = {
              --   ["async-trait"] = { "async_trait" },
              --   ["tauri_macros"] = { "generate_context" },
              --   ["sqlx_macros"] = { "test" },
              --   ["tokio_macros"] = { "test", "main" },
              -- },
            },
            imports = {
              granularity = {
                group = "module",
              },
            },
            inlayHints = {
              chainingHints = { enable = true },
              closingBraceHints = { enable = true, minLines = 25 },
              closureReturnTypeHints = { enable = "with_block" },
              lifetimeElisionHints = {
                enable = "never",
              },
              maxLength = 25,
              parameterHints = { enable = true },
              reborrowHints = { enable = "never" },
              typeHints = { enable = true },
            },
            hover = {
              actions = {
                references = { enable = true },
                run = { enable = true },
                debug = { enable = true },
                implementations = { enable = true },
              },
              memoryLayout = {
                niches = true,
                size = "both",
                alignment = "hexadecimal",
                offset = "hexadecimal",
              },
            },
            lens = {
              enable = true,
              run = { enable = true },
              debug = { enable = true },
              implementations = { enable = true },
            },
            -- clippyは重いが非常に有用。--no-depsでdependency checkをスキップして高速化
            check = {
              command = "clippy",
              extraArgs = { "--no-deps" },
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
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)

      local function set_keymaps(bufnr)
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc, buffer = bufnr })
        end
        map("<leader>cv", crates.show_versions_popup, "Crate Versions")
        map("<leader>cf", crates.show_features_popup, "Crate Features")
        map("<leader>ci", crates.show_dependencies_popup, "Crate Dependencies")
        map("<leader>cu", crates.update_crate, "Update Crate")
        map("<leader>cU", crates.update_all_crates, "Update All Crates")
        map("<leader>cg", crates.upgrade_crate, "Upgrade Crate")
        map("<leader>cG", crates.upgrade_all_crates, "Upgrade All Crates")
        map("<leader>co", crates.open_crates_io, "Open crates.io")
        map("<leader>cx", crates.open_documentation, "Open docs.rs")
        map("<leader>cr", crates.open_repository, "Open Repository")
      end

      set_keymaps(vim.api.nvim_get_current_buf())
      vim.api.nvim_create_autocmd("BufRead", {
        pattern = "Cargo.toml",
        callback = function(ev)
          set_keymaps(ev.buf)
        end,
      })
    end,
  },
}
