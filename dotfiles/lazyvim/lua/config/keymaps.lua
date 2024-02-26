local function cmd(command)
  return table.concat({ "<cmd>", command, "<CR>" })
end

local Util = require("lazyvim.util")
local map = vim.keymap.set
local del = vim.keymap.del

-- leave insert mode
map("i", "jk", "<esc>")

-- buffer cycle
map("n", "<Tab>", cmd("BufferLineCycleNext"))
map("n", "<S-Tab>", cmd("BufferLineCyclePrev"))
del("n", "<S-h>")
del("n", "<S-l>")

-- Telescope
map("n", "gp", cmd("Telescope registers"))

-- delete Terminal Mappings
del("t", "<C-h>")
del("t", "<C-j>")
del("t", "<C-k>")
del("t", "<C-l>")

-- Lsp
map({ "n", "v" }, "ga", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "gk", vim.lsp.buf.signature_help, { desc = "Signature help" })

-- format
map("n", "<leader>r", function()
  Util.format({ force = true })
end, { desc = "format" })

-- CodeRunner
map("n", "<leader>dm", function()
  require("lib.codeRunner").RunCode()
end, { desc = "CodeRunner" })

-- dap
map("n", "<leader>dM", function()
  require("lib.util").open_buf("AtCoder", "vsplit term://acct")
end, { desc = "AtCoder" })

-- noice
map("n", "<leader>nl", function()
  require("noice").cmd("last")
end, { desc = "Last message" })
map("n", "<leader>nf", function()
  require("noice").cmd("first")
end, { desc = "First message" })
map("n", "<leader>nh", function()
  require("noice").cmd("history")
end, { desc = "History" })
map("n", "<leader>na", function()
  require("noice").cmd("all")
end, { desc = "All" })
map("n", "<leader>nr", function()
  require("noice").cmd("refresh")
end, { desc = "Refresh" })
map("n", "<leader>nd", function()
  require("noice").cmd("dismiss")
end, { desc = "Dismiss" })
map("n", "<leader>ns", function()
  require("noice").cmd("search")
end, { desc = "Search" })

-- increment/decrement
map("n", "+", "<C-a>", { desc = "Increment" })
map("n", "-", "<C-x>", { desc = "Decrement" })

-- buffers
map("n", "<leader>bf", cmd("bfirst"), { desc = "First Buffer" })
map("n", "<leader>ba", cmd("blast"), { desc = "Last Buffer" })

-- Toggle statusline
map("n", "<leader>uS", function()
  if vim.opt.laststatus:get() == 0 then
    vim.opt.laststatus = 3
  else
    vim.opt.laststatus = 0
  end
end, { desc = "Toggle Statusline" })

-- Toggle tabline
map("n", "<leader>u<tab>", function()
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
