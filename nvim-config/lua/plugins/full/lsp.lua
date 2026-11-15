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

      -- Each host only has the servers of the lang.* modules it imports.
      -- vim.lsp.enable does not start a server whose cmd is not executable
      -- (it only logs that to lsp.log), so all of them can be enabled here.
      vim.lsp.enable({
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

      -- Configure diagnostics
      vim.diagnostic.config({
        -- tiny-inline-diagnostic.nvim draws the inline messages instead
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          source = "if_many",
          header = "",
          prefix = "",
        },
      })

      -- toggle keymap is provided by Snacks.toggle.inlay_hints() (<leader>uh)
      vim.lsp.inlay_hint.enable(true)
    end,

    -- stylua: ignore
    keys = {
      { "gk", function() vim.lsp.buf.signature_help() end, desc = "Signature Help" },
      { "gl", function() vim.lsp.codelens.run() end, desc = "CodeLens" },
      { "<leader>cd", function() vim.diagnostic.open_float() end, desc = "Line Diagnostics" },
      { "[d", function() vim.diagnostic.jump({ count = -1 }) end, desc = "Previous Diagnostic" },
      { "]d", function() vim.diagnostic.jump({ count = 1 }) end, desc = "Next Diagnostic" },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      options = {
        show_source = {
          enabled = true,
          if_many = true,
        },
        multilines = {
          enabled = true,
          always_show = true,
        },
        -- The default attaches on LspAttach only, which would leave buffers
        -- linted only by nvim-lint (dockerfile, GitHub Actions) without
        -- inline diagnostics now that virtual_text is off.
        overwrite_events = { "LspAttach", "DiagnosticChanged" },
        -- hide the inline text while <leader>cd shows the float
        override_open_float = true,
      },
    },
  },
}
