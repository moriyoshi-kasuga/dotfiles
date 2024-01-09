local Util = require("lazyvim.util")
local keymap = vim.keymap

-- leave insert mode
keymap.set("i", "jk", "<esc>")

-- delete Terminal Mappings
keymap.del("t", "<C-h>")
keymap.del("t", "<C-j>")
keymap.del("t", "<C-k>")
keymap.del("t", "<C-l>")

-- windows
keymap.set("n", "<leader>ws", "<C-W>s", { desc = "Split window horizontal" })
keymap.set("n", "<leader>wv", "<C-W>v", { desc = "Split window vertical" })

-- codeium
keymap.set("i", "<c-f>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true })
keymap.set("i", "<c-x>", function()
  return vim.fn["codeium#Clear"]()
end, { expr = true, silent = true })
-- format
keymap.set("n", "<leader>r", function()
  Util.format({ force = true })
end, { desc = "format" })

-- buffers
keymap.del("n", "<S-h>")
keymap.del("n", "<S-l>")
keymap.set("n","<A-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
keymap.set("n","<A-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
