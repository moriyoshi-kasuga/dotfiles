local M = {}

local term_cmd = "vsplit term://source ~/zsh/function/common.zsh && acct"
function M.run()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
      vim.api.nvim_buf_delete(buf, { force = true })
      break
    end
  end
  vim.cmd(term_cmd)
  vim.api.nvim_buf_set_keymap(0, "n", "q", ":bd!<cr>", { noremap = true, silent = true })
end

return M
