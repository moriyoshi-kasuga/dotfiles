---@type LazySpec[]
return {
  {
    "mason-org/mason.nvim",
    opts = {}
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {}
  },

  {
    "neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim"
		},
		---@class LspOpts
		---@field servers table<string, vim.lsp.Config>
		opts = {
			servers = {
				["*"] = {
					capabilities = {
						workspace = {
							fileOperations = {
								didRename = true,
								willRename = true,
							},
						},
					},
            -- stylua: ignore
            keys = {
              { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
              { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
              { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
              { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
              { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
              { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
              { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
              { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
            },
				},
				stylua = { enabled = false },
				lua_ls = {
					settings = {
						Lua = {
              runtime = {
                version = "LuaJIT",
                pathStrict = true,
                path = { "?.lua", "?/init.lua" },
              },
							workspace = {
                library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
                  "${3rd}/luv/library",
                  "${3rd}/busted/library",
                  "${3rd}/luassert/library",
                }),
								checkThirdParty = false,
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = "Replace",
							},
							doc = {
								privateName = { "^_" },
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
				},
			},
		},
		---@param opts LspOpts
		config = function(_, opts)
			if opts.servers["*"] then
				vim.lsp.config("*", opts.servers["*"])
			end

			---@return boolean? exclude automatic setup
			local function configure(server)
				if server == "*" then
					return false
        end
        local sopts = opts.servers[server]
        vim.lsp.config(server, sopts)
        vim.lsp.enable(server)
				return true
			end

			local mason_lsp_config_plugin = require("lazy.core.config").spec.plugins["mason-lspconfig.nvim"]
			local plugin_opts = require("lazy.core.plugin").values(mason_lsp_config_plugin, "opts", false)

			local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
			require("mason-lspconfig").setup({
				ensure_installed = vim.list_extend(install, plugin_opts.ensure_installed or {}),
        automatic_enable = { enable = false }
			})
		end,
	},
}
