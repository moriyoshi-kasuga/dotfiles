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
        "astro",
        "tailwindcss",

        "clangd",
        "ty",
        "nixd",
        "lua_ls",
        "hls",
        "fsautocomplete",
        "zls",

        "bashls",
        "jsonls",
        "taplo",
        "just",
        "asm_lsp",
        "gopls",
        "jdtls",
        "buf_ls",
        "elmls",

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
          border = "single",
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
        end,
      })
    end,

    -- stylua: ignore
    keys = {
      { "gk", function() vim.lsp.buf.signature_help() end, desc = "Signature Help" },
      { "<C-k>", function() vim.lsp.buf.signature_help() end, desc = "Signature Help", mode = "i" },
      { "<leader>cd", function() vim.diagnostic.open_float() end, desc = "Line Diagnostics" },
      { "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, desc = "Previous Diagnostic" },
      { "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, desc = "Next Diagnostic" },
    },
  },
}
