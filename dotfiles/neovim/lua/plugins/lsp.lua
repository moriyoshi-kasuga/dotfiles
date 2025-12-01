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
