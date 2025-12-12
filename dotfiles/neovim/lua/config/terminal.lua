-- Floating terminal implementation
-- Simple, temporary terminal for quick one-off commands
-- Designed to work alongside tmux for more complex terminal needs

local M = {}

-- Create a new temporary terminal buffer each time
local function create_terminal_buffer()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe" -- Automatically delete buffer when hidden
  return buf
end

-- Create floating window with centered position
local function create_floating_window(buf)
  local width = math.floor(vim.o.columns * 0.75)
  local height = math.floor(vim.o.lines * 0.85)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  vim.api.nvim_open_win(buf, true, win_config)
end

-- Setup terminal-specific keymaps
local function setup_terminal_keymaps(buf)
  -- Close terminal with <C-/>
  vim.keymap.set("t", "<C-/>", function()
    local win = vim.fn.bufwinid(buf)
    if win ~= -1 then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, desc = "Close Terminal" })

  -- Also allow Escape to exit terminal mode easily
  vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { buffer = buf, desc = "Exit Terminal Mode" })
end

-- Main toggle function
function M.toggle()
  -- Always create a new temporary terminal
  local buf = create_terminal_buffer()
  create_floating_window(buf)

  -- Start terminal in the buffer
  ---@diagnostic disable-next-line
  vim.fn.termopen(vim.o.shell, {
    on_exit = function()
      -- Clean up when terminal exits
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end,
  })

  -- Setup keymaps for this terminal
  setup_terminal_keymaps(buf)

  -- Enter insert mode immediately
  vim.cmd.startinsert()
end

-- Setup commands and keymaps
vim.api.nvim_create_user_command("FloatTerminal", M.toggle, {})
vim.keymap.set("n", "<C-/>", M.toggle, { desc = "Float Terminal" })

return M
