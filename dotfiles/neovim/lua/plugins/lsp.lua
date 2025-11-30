---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.lsp.config("*", (function()
        local opts = {}
        opts.capabilities = vim.lsp.protocol.make_client_capabilities()
        opts.capabilities.textDocument.completion.completionItem.snippetSupport = true
        opts.capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        }
        -- stylua: ignore
        opts.keys = {
          { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
          { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
          { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
          { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
          { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
          { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
          { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
          { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        }
        return opts
      end)())

      vim.lsp.enable({
        "efm",

        "nixd",
        "svelte",
        "vtsls",
        "lua_ls",
        "typos_lsp"
      })
    end,

    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        end,
      })
    end
	},
}
