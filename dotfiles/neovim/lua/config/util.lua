M = {}

---@return boolean
M.is_in_simple_mode = function()
  return vim.env.NVIM_SIMPLE_MODE == "1"
end

return M
