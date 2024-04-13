local M = {}

function M.cmd(command)
  return table.concat({ "<cmd>", command, "<cr>" })
end

return M
