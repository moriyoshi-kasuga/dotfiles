local Util = require("lazyvim.util")
local keymap = vim.keymap

-- leave insert mode
keymap.set("i", "jk", "<esc>")

-- delete Terminal Mappings
keymap.del("t", "<C-h>")
keymap.del("t", "<C-j>")
keymap.del("t", "<C-k>")
keymap.del("t", "<C-l>")

-- Lsp
keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, { desc = "Code action" })
keymap.set("n", "gk", vim.lsp.buf.signature_help, { desc = "Signature help" })

-- format
keymap.set("n", "<leader>r", function()
  Util.format({ force = true })
end, { desc = "format" })

-- buffers
keymap.del("n", "<S-h>")
keymap.del("n", "<S-l>")
keymap.set("n", "<A-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
keymap.set("n", "<A-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
