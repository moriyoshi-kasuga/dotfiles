local map = vim.keymap.set

map("n", "<leader>bo", function()
  local win_bufs = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    win_bufs[buf] = true
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if not win_bufs[buf] and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { desc = "Delete buffers not shown in any window" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Deleting without yanking empty line
map("n", "dd", function()
  return vim.api.nvim_get_current_line():match("^$") ~= nil and '"_dd' or "dd"
end, { noremap = true, expr = true, desc = "Don't yank empty line to clipboard" })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

map("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
map("n", "<leader>ws", "<C-w>s", { desc = "Horizontal split" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close Other window" })

map("n", "<leader>h", "<cmd>noh<CR>", { desc = "clear highlights" })

-- better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

map("n", "<leader><Tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><Tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tab" })
map("n", "<leader><Tab>n", "<cmd>tabnext<cr>", { desc = "Tab Next" })
map("n", "<leader><Tab>p", "<cmd>tabprevious<cr>", { desc = "Tab Prev" })
map("n", "[t", "<cmd>tabprevious<cr>", { desc = "Prev Tab" })
map("n", "]t", "<cmd>tabnext<cr>", { desc = "Next Tab" })

map("n", "=", [[<cmd>vertical resize +5<cr>]], { desc = "Increase window width" })
map("n", "-", [[<cmd>vertical resize -5<cr>]], { desc = "Decrease window width" })
map("n", "+", [[<cmd>horizontal resize +2<cr>]], { desc = "Increase window height" })
map("n", "_", [[<cmd>horizontal resize -2<cr>]], { desc = "Decrease window height" })

map("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })
