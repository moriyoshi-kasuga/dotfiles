vim.opt.signcolumn = "no"
vim.o.statuscolumn = "%!v:lua.MoriStatusColumn()"
vim.opt.numberwidth = 3

_G.MoriStatusColumn = function()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local digits = math.max(#tostring(vim.api.nvim_buf_line_count(buf)), 3)

  -- wrapped / virtual lines: blank space of same width, no number
  if vim.v.virtnum ~= 0 then
    return string.rep(" ", digits + 1)
  end

  local lnum = vim.v.lnum
  local relnum = vim.v.relnum
  local highlight

  -- Priority 1: Diagnostics
  local diags = vim.diagnostic.get(buf, { lnum = lnum - 1 })
  if #diags > 0 then
    local worst = vim.diagnostic.severity.HINT
    for _, d in ipairs(diags) do
      if d.severity < worst then
        worst = d.severity
      end
    end
    if worst == vim.diagnostic.severity.ERROR then
      highlight = "%#DiagnosticError#"
    elseif worst == vim.diagnostic.severity.WARN then
      highlight = "%#DiagnosticWarn#"
    elseif worst == vim.diagnostic.severity.INFO then
      highlight = "%#DiagnosticInfo#"
    else
      highlight = "%#DiagnosticHint#"
    end
  end

  -- Priority 2: Current line
  if not highlight and relnum == 0 then
    highlight = "%#Constant#"
  end

  local number = relnum == 0 and lnum or relnum
  return (highlight or "") .. string.format("%" .. digits .. "s ", number)
end
