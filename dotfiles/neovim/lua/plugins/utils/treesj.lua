return {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	keys = { "<leader>j", "<leader>J" },
	opts = {
		use_default_keymaps = false,
		max_join_length = 1200,
	},
	config = function(_, opts)
		require("treesj").setup(opts)
		vim.keymap.set("n", "<leader>j", require("treesj").toggle, { desc = "Toggle split" })
		vim.keymap.set("n", "<leader>J", function()
			require("treesj").toggle({ split = { recursive = true } })
		end, { desc = "Toggle split (recursive)" })
	end,
}
