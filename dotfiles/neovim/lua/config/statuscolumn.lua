vim.opt.signcolumn = "no"
vim.o.statuscolumn = "%!v:lua.StatusColumnFn()";
vim.opt.numberwidth = 3

_G.StatusColumnFn = function()
  local highlight = ""
  local number = vim.v.relnum
  if number == 0 then
    highlight = "%#CmpItemKindConstant#"
    number = vim.v.lnum
  end

  local max_line = vim.fn.line('$')
  local digits = math.max(#tostring(max_line), 3)
  return highlight .. string.format("%" .. digits .. "s ", number)
end
