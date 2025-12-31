vim.opt.signcolumn = "no"
vim.o.statuscolumn = "%!v:lua.MoriStatusColumn()"
vim.opt.numberwidth = 3

_G.MoriStatusColumn = function()
  local highlight = ""
  local number = vim.v.relnum
  if number == 0 then
    local is_recording = vim.fn.reg_recording() ~= ""
    highlight = is_recording and "%#Macro#" or "%#Constant#"
    number = vim.v.lnum
  end

  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local max_line = vim.api.nvim_buf_line_count(buf)
  local digits = math.max(#tostring(max_line), 3)
  return highlight .. string.format("%" .. digits .. "s ", number)
end
