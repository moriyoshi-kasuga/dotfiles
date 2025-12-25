---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      -- Setup capabilities for blink.cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Merge blink.cmp capabilities
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
      end

      -- Add file operation capabilities
      capabilities.workspace = capabilities.workspace or {}
      capabilities.workspace.fileOperations = {
        didRename = true,
        willRename = true,
      }

      -- Configure LSP settings
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Enable LSP servers
      -- Note: All LSP servers should be installed via Nix
      vim.lsp.enable({
        "svelte",
        "vtsls",

        "clangd",
        "ty",
        "nixd",
        "lua_ls",
        "hls",
        "fsautocomplete",
        "zls",
        "jdtls",
        "metals",

        "bashls",
        "jsonls",
        "typos_lsp",
        "tombi",
        "just",

        -- vscode-html-language-server
        "html",
        -- vscode-css-language-server
        "cssls",
      })

      -- Configure diagnostics
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
          header = "",
          prefix = "",
        },
      })
    end,

    init = function()
      -- LSP keybindings on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc, silent = true })
          end

          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
            map("n", "<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
            end, "Toggle Inlay Hints")
          end

          local fzf = require("fzf-lua")

          -- Navigation with fzf-lua
          map("n", "ga", function()
            fzf.lsp_code_actions()
          end, "Goto Definition")
          map("n", "gd", function()
            fzf.lsp_definitions()
          end, "Goto Definition")
          map("n", "gD", function()
            fzf.lsp_declarations()
          end, "Goto Declaration")
          map("n", "gr", function()
            fzf.lsp_references()
          end, "References")
          map("n", "gI", function()
            fzf.lsp_implementations()
          end, "Goto Implementation")
          map("n", "gy", function()
            fzf.lsp_typedefs()
          end, "Goto T[y]pe Definition")
          map("n", "gsi", function()
            fzf.lsp_incoming_calls()
          end, "Call[s] Incoming")
          map("n", "gso", function()
            fzf.lsp_outgoing_calls()
          end, "Call[s] Outgoing")

          -- Hover and signature help
          map("n", "K", function()
            vim.lsp.buf.hover({ border = "rounded", max_height = 25, max_width = 120, wrap = false })
          end, "Hover")
          map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")

          -- Show line diagnostics
          map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")

          -- Diagnostic navigation
          map("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, "Previous Diagnostic")
          map("n", "]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, "Next Diagnostic")
        end,
      })
    end,
  },
}
