---@type LazySpec[]
return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{
				"<leader>r",
				function()
					require("conform").format({
						lsp_fallback = true,
						async = false,
						timeout_ms = 1000,
					})
				end,
				mode = { "n", "v" },
				desc = "Format buffer or selection",
			},
		},
		opts = {
			-- Configure formatters by filetype
			-- Note: All formatters should be installed via Nix
			formatters_by_ft = {
				lua = { "stylua" },
				-- Example for other languages:
				-- rust = { "rustfmt" },
				-- go = { "gofmt", "goimports" },
				-- nix = { "nixpkgs-fmt" },
				-- javascript = { "prettier" },
				-- typescript = { "prettier" },
				-- svelte = { "prettier" },
				-- c = { "clang-format" },
				-- zig = { "zigfmt" },
			},

			-- Customize formatter settings if needed
			formatters = {
				-- Example for stylua:
				-- stylua = {
				--   prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
				-- },
			},

			-- Disable auto-formatting on save (as requested)
			format_on_save = false,

			-- Format after these milliseconds of no cursor movement
			format_after_save = false,
		},
	},
}
