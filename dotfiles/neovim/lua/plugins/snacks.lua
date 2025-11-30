---@type LazySpec
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	init = function()
		vim.print = function(...)
			Snacks.debug.inspect(...)
		end

		vim.api.nvim_create_user_command("Bdelete", function()
			Snacks.bufdelete()
		end, { nargs = 0 })
		vim.api.nvim_create_user_command("Bdeleteall", function()
			Snacks.bufdelete.all()
		end, { nargs = 0 })
	end,
	keys = {
		{
			"s",
			enable = false,
		},
		{
			",",
			enable = false,
		},
		{
			",<cr>",
			function()
				Snacks.picker.picker_actions()
			end,
			desc = "Picker Actions",
		},
		{
			",g",
			function()
				Snacks.picker.grep({
					hidden = true,
				})
			end,
			desc = "Grep",
		},
		{
			",B",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Grep Buffers",
		},
		{
			",w",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Grep String",
			mode = { "n", "x" },
		},
		{
			",b",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			",c",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Colorscheme",
		},
		{
			",s",
			function()
				Snacks.picker.files({
					hidden = true,
				})
			end,
			desc = "Find Files",
		},
		{
			",h",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		{
			",j",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumplist",
		},
		{
			",l",
			function()
				Snacks.picker.lazy()
			end,
			desc = "Lazy",
		},
		{
			",m",
			function()
				Snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			",p",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		{
			",q",
			function()
				Snacks.picker.qflist()
			end,
			desc = "qflist",
		},
		{
			",r",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			",d",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
		},
		{
			",D",
			function()
				Snacks.picker.diagnostics()
			end,
		},
		{
			"<leader>d",
			function()
				if Snacks.dim.enabled then
					Snacks.dim.disable()
				else
					Snacks.dim.enable()
				end
			end,
			desc = "Dim",
		},
	},
	---@type snacks.Config
	opts = {
		input = {
			enabled = true,
		},
		picker = {
			ui_select = true,
			formatters = {
				file = {
					filename_first = true,
					truncate = 400,
				},
			},
		},
		bigfile = {
			enabled = true,
		},
		debug = {
			enabled = true,
		},
	},
}
