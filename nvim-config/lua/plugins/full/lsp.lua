return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- blink.cmp registers its capabilities through vim.lsp.config("*") when it
    -- loads, so it has to load before any server is enabled here.
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      -- Per-server settings (vtsls, astro, lua_ls, nixd, ...) live under after/lsp/*.lua
      -- and are merged in automatically; this file only handles cross-server setup.

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
        "ruff",
        "nixd",
        "lua_ls",
        "hls",

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
        jump = {
          on_jump = function(_, bufnr)
            vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
          end,
        },
      })

      -- toggle keymap is provided by Snacks.toggle.inlay_hints() (<leader>uh)
      vim.lsp.inlay_hint.enable(true)
    end,

    -- stylua: ignore
    keys = {
      { "gk", function() vim.lsp.buf.signature_help() end, desc = "Signature Help" },
      { "gl", function() vim.lsp.codelens.run() end, desc = "CoreLens" },
      { "<leader>cd", function() vim.diagnostic.open_float() end, desc = "Line Diagnostics" },
      { "[d", function() vim.diagnostic.jump({ count = -1 }) end, desc = "Previous Diagnostic" },
      { "]d", function() vim.diagnostic.jump({ count = 1 }) end, desc = "Next Diagnostic" },
    },
  },
}
