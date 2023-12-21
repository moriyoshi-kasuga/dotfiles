local keymap = vim.keymap

keymap.del("n", "<leader>l")

keymap.set("i", "jk", "<esc>")

keymap.del("n", "<leader>xl")
keymap.del("n", "<leader>xq")

keymap.del("n", "[q")
keymap.del("n", "]q")

-- LazyVim Changelog
keymap.del("n", "<leader>L")

-- floating terminal
keymap.del("n", "<leader>ft")
keymap.del("n", "<leader>fT")

-- Terminal Mappings
keymap.del("t", "<C-h>")
keymap.del("t", "<C-j>")
keymap.del("t", "<C-k>")
keymap.del("t", "<C-l>")

-- windows
keymap.del("n", "<leader>w-")
keymap.del("n", "<leader>w|")
keymap.del("n", "<leader>-")
keymap.del("n", "<leader>|")
keymap.set("n", "<leader>ws", "<C-W>s", { desc = "Split window horizontal", remap = true })
keymap.set("n", "<leader>wv", "<C-W>v", { desc = "Split window vertical", remap = true })
-- format
keymap.set("n", "<leader>r", function()
  require("conform").format()
end, { desc = "Format code", remap = true })
-- codeium
keymap.set("i", "<c-f>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true })
keymap.set("i", "<c-x>", function()
  return vim.fn["codeium#Clear"]()
end, { expr = true, silent = true })
