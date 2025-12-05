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
				"nixd",
				"svelte",
				"vtsls",
				"lua_ls",
				"typos_lsp",
				-- Add other LSP servers as needed:
				-- "rust_analyzer",
				-- "gopls",
				-- "zls",
				-- "clangd",
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
						vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
					end

					local snacks_picker = require("snacks.picker")

					-- Navigation with Snacks.nvim picker
					map("n", "gd", function()
						snacks_picker.lsp_definitions()
					end, "Goto Definition")
					map("n", "gD", function()
						snacks_picker.lsp_declarations()
					end, "Goto Declaration")
					map("n", "gr", function()
						snacks_picker.lsp_references()
					end, "References")
					map("n", "gI", function()
						snacks_picker.lsp_implementations()
					end, "Goto Implementation")
					map("n", "gy", function()
						snacks_picker.lsp_type_definitions()
					end, "Goto T[y]pe Definition")
					map("n", "gsi", function()
						snacks_picker.lsp_incoming_calls()
					end, "Call[s] Incoming")
					map("n", "gso", function()
						snacks_picker.lsp_outgoing_calls()
					end, "Call[s] Outgoing")

					-- Hover and signature help
					map("n", "K", vim.lsp.buf.hover, "Hover")
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
