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

      -- vtsls does not enable inlay hints on its own; turn them on so the
      -- LspAttach hook (which only toggles visibility) actually has hints to show.
      local ts_inlay_hints = {
        parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true, suppressWhenTypeMatchesName = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      }
      vim.lsp.config("vtsls", {
        settings = {
          typescript = { inlayHints = ts_inlay_hints },
          javascript = { inlayHints = ts_inlay_hints },
        },
      })

      -- astro-language-server has no bundled TypeScript and, under Nix, no global
      -- install to discover. Hand it the SDK path exported via TSDK_PATH.
      local tsdk = vim.env.TSDK_PATH
      if tsdk and tsdk ~= "" then
        vim.lsp.config("astro", {
          init_options = { typescript = { tsdk = tsdk } },
        })
      end

      -- denols and vtsls coexist safely: lspconfig attaches denols only inside a
      -- deno.json/deno.lock project and makes vtsls stand down there, so enabling
      -- both gives correct LSP in deno and npm trees without double-attaching.

      -- Enable LSP servers whose binaries are available on PATH.
      -- Server configs are registered by nvim-lspconfig via vim.lsp.config.
      local function safe_lsp_enable(servers)
        local to_enable = {}
        for _, server in ipairs(servers) do
          local cfg = vim.lsp.config[server]
          if not cfg then
            -- config not registered by lspconfig; skip silently
          elseif not cfg.cmd then
            -- no explicit cmd (e.g. stdin-based server); enable unconditionally
            table.insert(to_enable, server)
          elseif type(cfg.cmd) == "function" then
            -- dynamic cmd; delegate availability check to Neovim
            table.insert(to_enable, server)
          elseif vim.fn.executable(cfg.cmd[1]) == 1 then
            table.insert(to_enable, server)
          end
        end
        if #to_enable > 0 then
          vim.lsp.enable(to_enable)
        end
      end

      safe_lsp_enable({
        "svelte",
        "vtsls",
        "denols",
        "astro",
        "tailwindcss",
        "eslint",

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
        "buf_ls",
        "elmls",
        "tinymist",

        -- vscode-html-language-server
        "html",
        -- vscode-css-language-server
        "cssls",
      })

      -- Suppress diagnostics published for files under .metals/
      local orig_publish_diags = vim.lsp.handlers["textDocument/publishDiagnostics"]
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        if result and result.uri and result.uri:find("/.metals/", 1, true) then
          return
        end
        orig_publish_diags(err, result, ctx, config)
      end

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
      { "gl", function() vim.lsp.codelens.run() end, desc = "CoreLens" },
      { "<leader>cd", function() vim.diagnostic.open_float() end, desc = "Line Diagnostics" },
      { "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, desc = "Previous Diagnostic" },
      { "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, desc = "Next Diagnostic" },
    },
  },
}
