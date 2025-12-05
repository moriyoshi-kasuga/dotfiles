---@type LazySpec[]
return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile", "BufWritePost" },
		config = function()
			local lint = require("lint")

			-- Configure linters by filetype
			-- Note: All linters should be installed via Nix
			lint.linters_by_ft = {
				lua = { "luacheck" },
				-- Example for other languages:
				-- rust = { "clippy" },
				-- go = { "golangci-lint" },
				-- nix = { "nix" },
				-- typescript = { "eslint" },
				-- javascript = { "eslint" },
				-- svelte = { "eslint" },
			}

			-- Customize linter settings if needed
			-- Example for luacheck:
			lint.linters.luacheck.args = {
				"--globals",
				"vim",
				"--formatter",
				"plain",
				"--codes",
				"--ranges",
				"-",
			}

			-- Auto-lint on these events
			local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					-- Only lint if linter is configured for this filetype
					local linters = lint.linters_by_ft[vim.bo.filetype]
					if linters and #linters > 0 then
						lint.try_lint()
					end
				end,
			})

			-- Create a command to manually trigger linting
			vim.api.nvim_create_user_command("Lint", function()
				lint.try_lint()
			end, {
				desc = "Trigger linting for current file",
			})
		end,
	},
}
