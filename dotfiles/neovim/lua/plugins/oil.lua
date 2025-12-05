return {
	{
		"stevearc/oil.nvim",
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		keys = {
			{ "<leader>e", "<cmd>Oil<CR>" },
		},
	},
}
