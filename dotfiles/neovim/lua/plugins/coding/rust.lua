return {
	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			completion = {
				crates = {
					enabled = true,
				},
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},

	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,
		opts = {
			tools = {
				hover_actions = {
					replace_builtin_hover = false,
				},
			},
			server = {
				on_attach = function(_, bufnr)
					vim.keymap.set(
						"n",
						"<leader>cx",
						"<cmd>RustLsp openDocs<cr>",
						{ silent = true, desc = "Open docs", buffer = bufnr }
					)
					vim.keymap.set(
						"n",
						"<leader>cm",
						"<cmd>RustLsp rebuildProcMacros<cr>",
						{ silent = true, desc = "Rebuild ProcMacros", buffer = bufnr }
					)
					vim.keymap.set(
						"n",
						"<leader>ce",
						"<cmd>RustLsp explainError<cr>",
						{ silent = true, desc = "Explain Error", buffer = bufnr }
					)
					vim.keymap.set(
						"n",
						"<leader>co",
						"<cmd>RustLsp expandMacro<cr>",
						{ silent = true, desc = "Expand Macro", buffer = bufnr }
					)
					vim.keymap.set(
						"n",
						"<leader>ct",
						"<cmd>RustLsp parentModule<cr>",
						{ silent = true, desc = "Goto Parent Module", buffer = bufnr }
					)
				end,
				default_settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							buildScripts = {
								enable = true,
							},
						},
						diagnostics = {
							disabled = { "macro-error", "proc-macro-disabled" },
						},
						procMacro = {
							enable = true,
							ignored = {
								["async-trait"] = { "async_trait" },
								["tauri_macros"] = { "generate_context" },
								["sqlx_macros"] = { "test" },
								["tokio_macros"] = { "test", "main" },
							},
						},

						-- clippyは非常に重いため、cargo checkで代用する
						check = {
							command = "check",
						},
						checkOnSave = {
							command = "check",
						},

						files = {
							excludeDirs = {
								"**/.git",
								"**/node_modules",
								"**/target",
								"**/vendor",
								"**/.svelte-kit",
								"**/build",
							},
							exclude = {
								"**/.git",
								"**/node_modules",
								"**/target",
								"**/vendor",
								"**/.svelte-kit",
								"**/build",
							},
							watcher = "client",
						},
					},
				},
			},
		},
		config = function(_, opts)
			vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
		end,
	},

	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			local is_dioxus_project = vim.fs.root(0, { "Dioxus.toml" }) ~= nil
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			if is_dioxus_project then
				opts.formatters_by_ft.rust = { "dioxus", lsp_format = "first" }
			end
		end,
	},
}
