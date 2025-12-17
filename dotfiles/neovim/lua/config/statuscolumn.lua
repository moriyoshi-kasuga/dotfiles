vim.opt.signcolumn = "no"
vim.o.statuscolumn = "%!v:lua.StatusColumnFn()"
vim.opt.numberwidth = 3

_G.StatusColumnFn = function()
  local highlight = ""
  local number = vim.v.relnum
  if number == 0 then
    highlight = "%#BlinkCmpKindConstant#"
    number = vim.v.lnum
  end

  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local max_line = vim.api.nvim_buf_line_count(buf)
  local digits = math.max(#tostring(max_line), 3)
  return highlight .. string.format("%" .. digits .. "s ", number)
end
