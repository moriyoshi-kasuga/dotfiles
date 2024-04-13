local map = vim.keymap.set
local del = vim.keymap.del

local cmd = require("util.utils").cmd

-- insert mode
map("i", "jk", "<esc>")
map("i", "<C-f>", "<right>")
map("i", "<C-b>", "<left>")
map("i", "<C-n>", "<down>")
map("i", "<C-p>", "<up>")

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

map("n", "<Tab>", cmd "bprevious", { desc = "Prev Buffer" })
map("n", "<S-Tab>", cmd "bnext", { desc = "Next Buffer" })
map("n", "[b", cmd "bprevious", { desc = "Prev Buffer" })
map("n", "]b", cmd "bnext", { desc = "Next Buffer" })
map("n", "<leader>bb", cmd "e #", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", cmd "e #", { desc = "Switch to Other Buffer" })
map("n", "<leader>bf", cmd "bfirst", { desc = "First Buffer" })
map("n", "<leader>ba", cmd "blast", { desc = "Last Buffer" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")


-- Deleting without yanking empty line
map("n", "dd", function()
  return vim.api.nvim_get_current_line():match("^$") ~= nil and '"_dd' or "dd"
end, { noremap = true, expr = true, desc = "Don't yank empty line to clipboard" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- tabs
map("n", "<leader><tab>l", cmd "tablast", { desc = "Last Tab" })
map("n", "<leader><tab>f", cmd "tabfirst", { desc = "First Tab" })
map("n", "<leader><tab><tab>", cmd "tabnew", { desc = "New Tab" })
map("n", "<leader><tab>]", cmd "tabnext", { desc = "Next Tab" })
map("n", "<leader><tab>d", cmd "tabclose", { desc = "Close Tab" })
map("n", "<leader><tab>[", cmd "tabprevious", { desc = "Previous Tab" })
