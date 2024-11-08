local function cmd(command)
  return table.concat({ "<cmd>", command, "<CR>" })
end

local map = vim.keymap.set
local del = vim.keymap.del

-- buffer cycle
del("n", "<S-h>")
del("n", "<S-l>")

-- del move lines
del("n", "<A-j>")
del("n", "<A-k>")
del("i", "<A-j>")
del("i", "<A-k>")
del("v", "<A-j>")
del("v", "<A-k>")

del({ "i", "n" }, "<esc>")
map("n", "<leader>h", cmd("noh"))

-- Telescope
map("n", "<leader>\\", cmd("Telescope current_buffer_fuzzy_find"))
map("n", "<leader>se", function()
  require("telescope.builtin").diagnostics({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Error Diagnostics" })
map("n", "<leader>sE", function()
  require("telescope.builtin").diagnostics({ severity = { min = vim.diagnostic.severity.WARN } })
end, { desc = "Warning Diagnostics" })

-- Lsp
map({ "n", "v" }, "ga", vim.lsp.buf.code_action, { desc = "Code action" })

-- Toggle statusline
map("n", "<leader>uS", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt.laststatus:get() == 0 then
    vim.opt.laststatus = 3
  else
    vim.opt.laststatus = 0
  end
end, { desc = "Toggle Statusline" })

-- Toggle tabline
map("n", "<leader>u<tab>", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt.showtabline:get() == 0 then
    vim.opt.showtabline = 2
  else
    vim.opt.showtabline = 0
  end
end, { desc = "Toggle Tabline" })

-- Deleting without yanking empty line
map("n", "dd", function()
  return vim.api.nvim_get_current_line():match("^$") ~= nil and '"_dd' or "dd"
end, { noremap = true, expr = true, desc = "Don't yank empty line to clipboard" })

-- delete key somethings
del("n", "<leader>l")
del("n", "<leader>L")
del("n", "<leader>K")
del("n", "<leader>|")
del("n", "<leader>-")
del("n", "<leader>`")

map("n", "<leader><c-_>", function()
  ---@diagnostic disable-next-line: redundant-parameter
  LazyVim.terminal(nil, { cwd = vim.fn.expand("%:p:h") })
end, { desc = "Open Terminal with current dir" })

map("v", "<leader>cn", ":CarbonNow<CR>", { silent = true })
