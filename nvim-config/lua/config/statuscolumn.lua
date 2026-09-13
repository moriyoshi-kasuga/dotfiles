vim.opt.signcolumn = "no"
vim.o.statuscolumn = "%!v:lua.MoriStatusColumn()"
vim.opt.numberwidth = 3

local function git_hunk_highlight(buf, lnum)
  local ok, gitsigns = pcall(require, "gitsigns")
  if not ok then
    return nil
  end

  local hunks = gitsigns.get_hunks(buf)
  if not hunks then
    return nil
  end

  for _, hunk in ipairs(hunks) do
    local added = hunk.added
    local removed = hunk.removed
    if added.count > 0 then
      if lnum >= added.start and lnum < added.start + added.count then
        return removed.count > 0 and "GitSignsChange" or "GitSignsAdd"
      end
    elseif removed.count > 0 and lnum == math.max(added.start, 1) then
      return "GitSignsDelete"
    end
  end

  return nil
end

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

  -- Priority 2: Git hunks
  if not highlight then
    local git_hl = git_hunk_highlight(buf, lnum)
    if git_hl then
      highlight = "%#" .. git_hl .. "#"
    end
  end

  -- Priority 3: Current line
  if not highlight and relnum == 0 then
    highlight = "%#Constant#"
  end

  local number = relnum == 0 and lnum or relnum
  return (highlight or "") .. string.format("%" .. digits .. "s ", number)
end
