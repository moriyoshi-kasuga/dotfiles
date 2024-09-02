local function cmd(command)
  return table.concat({ "<cmd>", command, "<CR>" })
end

local map = vim.keymap.set
local del = vim.keymap.del

-- buffer cycle
map("n", "<Tab>", cmd("BufferLineCycleNext"))
map("n", "<S-Tab>", cmd("BufferLineCyclePrev"))
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
map({ "n", "v" }, "gp", cmd("Telescope registers"))
map("n", "<leader>m", cmd("Telescope current_buffer_fuzzy_find"))

-- delete Terminal Mappings
del("t", "<C-h>")
del("t", "<C-j>")
del("t", "<C-k>")
del("t", "<C-l>")

-- Lsp
map({ "n", "v" }, "ga", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "gk", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "gd", function()
  require("telescope.builtin").lsp_definitions({ reuse_win = true })
end, { desc = "Goto Definition" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

-- increment/decrement
map("n", "+", "<C-a>", { desc = "Increment" })
map("n", "-", "<C-x>", { desc = "Decrement" })

-- buffers
map("n", "<leader>bf", cmd("bfirst"), { desc = "First Buffer" })
map("n", "<leader>ba", cmd("blast"), { desc = "Last Buffer" })

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

-- Git
map("n", "<leader>ug", cmd("Gitsigns toggle_current_line_blame"), { desc = "Toggle Git blame" })

-- delete key somethings
del("n", "<leader>l")
del("n", "<leader>L")
del("n", "<leader>K")
del("n", "<leader>E")
del("n", "<leader>|")
del("n", "<leader>-")
del("n", "<leader>`")

-- outline
map("n", "gs", cmd("AerialToggle"))

map("n", "<leader><c-_>", function()
  LazyVim.terminal(nil, { cwd = vim.fn.expand("%:p:h") })
end, { desc = "Open Terminal with current dir" })

map("v", "<leader>cn", ":CarbonNow<CR>", { silent = true })

-- mark
-- map("n", "M", function()
--   local char = vim.fn.getcharstr()
--   vim.cmd("delmarks " .. char)
-- end, { desc = "Delete Mark" })
-- map("n", "<leader>m", cmd("Telescope marks"), { desc = "Browse marks with telescoe" })
