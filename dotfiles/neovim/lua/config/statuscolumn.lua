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
  -- 大抵は1000行以下。あまりにも多い場合はなにか対策する
  return highlight .. string.format("%3s", number)
end
