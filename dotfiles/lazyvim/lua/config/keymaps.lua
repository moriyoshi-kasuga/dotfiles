local function cmd(command)
  return table.concat({ "<cmd>", command, "<CR>" })
end

local map = vim.keymap.set
local del = vim.keymap.del

del({ "i", "n" }, "<esc>")
map("n", "<leader>h", cmd("noh"))

for _, quote in ipairs({ '"', "'", "`" }) do
  map({ "x", "o" }, "a" .. quote, "2i" .. quote)
end

map("n", "<leader>r", function()
  LazyVim.format.format({ force = true })
end, { desc = "Format buffer" })

-- window
map("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
map("n", "<leader>ws", "<C-w>s", { desc = "Horizontal split" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close Other window" })

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

map("n", "<leader>bO", function()
  vim.cmd("only")
  Snacks.bufdelete.other({})
end, { desc = "Delete other buffers and Close other windows" })

-- FzfLua
map("n", "<leader>\\", cmd("FzfLua grep_curbuf"))
map("n", "<leader>se", cmd("FzfLua diagnostics_workspace severity_limit=2"), { desc = "Warn Diagnostics" })
map("n", "<leader>sE", cmd("FzfLua diagnostics_workspace severity_limit=1"), { desc = "Error Diagnostics" })

-- Lsp
map({ "n", "v" }, "ga", function()
  require("fzf-lua").lsp_code_actions({
    winopts = {
      width = 0.8,
      height = 0.8,
      preview = {
        vertical = "down:70%",
        layout = "vertical",
      },
    },
  })
end, { desc = "Code actions" })

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

-- delete key somethings
del("n", "<leader>l")
del("n", "<leader>|")
del("n", "<leader>-")
del("n", "<leader>`")

map("n", "<leader><c-_>", function()
  ---@diagnostic disable-next-line: redundant-parameter
  Snacks.terminal(nil, { cwd = vim.fn.expand("%:p:h") })
end, { desc = "Open Terminal with current dir" })

map("v", "<leader>cn", ":CarbonNow<CR>", { silent = true })

-- disable of git keymaps by LazyVim
del("n", "<leader>gg")
del("n", "<leader>gG")
del("n", "<leader>gl")
del("n", "<leader>gL")
del("n", "<leader>gb")
del("n", "<leader>gB")
del("n", "<leader>gY")
del("n", "<leader>gc")
