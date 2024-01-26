local Util = require("lazyvim.util")
local keymap = vim.keymap

-- leave insert mode
keymap.set("i", "jk", "<esc>")

-- buffer cycle
keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>")
keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>")
keymap.del("n", "<S-h>")
keymap.del("n", "<S-l>")

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

-- RunCode
keymap.set("n", "<leader>dm", function()
  require("util.util").RunCode()
end, { desc = "CodeRunner" })
