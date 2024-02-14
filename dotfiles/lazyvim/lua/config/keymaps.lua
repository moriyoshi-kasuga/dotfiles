local Util = require("lazyvim.util")
local keymap = vim.keymap

-- leave insert mode
keymap.set("i", "jk", "<esc>")

-- buffer cycle
keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>")
keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>")
keymap.del("n", "<S-h>")
keymap.del("n", "<S-l>")

-- Telescope
keymap.set("n", "gp", "<cmd>Telescope registers<cr>")

-- delete Terminal Mappings
keymap.del("t", "<C-h>")
keymap.del("t", "<C-j>")
keymap.del("t", "<C-k>")
keymap.del("t", "<C-l>")

-- windows
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Horizontal split" })
keymap.set("n", "<leader>wo", "<C-w>o", { desc = "Close Other window" })

-- Lsp
keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, { desc = "Code action" })
keymap.set("n", "gk", vim.lsp.buf.signature_help, { desc = "Signature help" })

-- format
keymap.set("n", "<leader>r", function()
  Util.format({ force = true })
end, { desc = "format" })

-- CodeRunner
keymap.set("n", "<leader>dm", function()
  require("lib.codeRunner").RunCode()
end, { desc = "CodeRunner" })

-- dap
keymap.set("n", "<leader>dM", function()
  require("lib.util").open_buf("AtCoder", "vsplit term://acct")
end, { desc = "AtCoder" })

-- noice
keymap.set("n", "<leader>nl", function()
  require("noice").cmd("last")
end, { desc = "Last message" })
keymap.set("n", "<leader>nf", function()
  require("noice").cmd("first")
end, { desc = "First message" })
keymap.set("n", "<leader>nh", function()
  require("noice").cmd("history")
end, { desc = "History" })
keymap.set("n", "<leader>na", function()
  require("noice").cmd("all")
end, { desc = "All" })
keymap.set("n", "<leader>nr", function()
  require("noice").cmd("refresh")
end, { desc = "Refresh" })
keymap.set("n", "<leader>nd", function()
  require("noice").cmd("dismiss")
end, { desc = "Dismiss" })
keymap.set("n", "<leader>ns", function()
  require("noice").cmd("search")
end, { desc = "Search" })
