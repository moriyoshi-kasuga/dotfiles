local function cmd(command)
  return table.concat({ "<Cmd>", command, "<CR>" })
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

-- windows
map("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
map("n", "<leader>ws", "<C-w>s", { desc = "Horizontal split" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close Other window" })

map("n", "<C-w>z", cmd("WindowsMaximize"))
map("n", "<C-w>_", cmd("WindowsMaximizeVertically"))
map("n", "<C-w>|", cmd("WindowsMaximizeHorizontally"))
map("n", "<C-w>=", cmd("WindowsEqualize"))
map("n","<leader>wz",cmd("WindowsMaximize"))

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

