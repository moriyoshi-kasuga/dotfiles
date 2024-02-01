local M = {}

local term_cmd = "vsplit term://source ~/zsh/function/common.zsh && acct"
function M.run()
  vim.cmd(term_cmd)
end

return M
