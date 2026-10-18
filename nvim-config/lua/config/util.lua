local M = {}

---@return boolean
M.is_in_simple_mode = function()
  return vim.env.NVIM_SIMPLE_MODE == "1"
end

-- Run an LSP request that returns Locations (e.g. a file-references request)
-- and show the result in fzf-lua's quickfix picker, the same way `gr` does
-- for the built-in references handler.
---@param bufnr integer
---@param method string
---@param params any
M.lsp_locations_to_fzf = function(bufnr, method, params)
  vim.lsp.buf_request(bufnr, method, params, function(err, result, ctx)
    if err or not result or vim.tbl_isempty(result) then
      return
    end
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local items = vim.lsp.util.locations_to_items(result, client and client.offset_encoding or "utf-16")
    vim.fn.setqflist(items)
    require("fzf-lua").quickfix()
  end)
end

-- Copy a path to the clipboard registers.
---@param path string
M.copy_path = function(path)
  vim.fn.setreg("*", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end

-- Pick one of the candidates with vim.ui.select and copy its path.
-- fzf.lua sizes the picker for the "copy_path" kind.
---@param candidates {label: string, value: string}[]
M.select_path_to_copy = function(candidates)
  vim.ui.select(candidates, {
    prompt = "Copy Path:",
    kind = "copy_path",
    format_item = function(item)
      return string.format("%-20s %s", item.label, item.value)
    end,
  }, function(item)
    if item then
      M.copy_path(item.value)
    end
  end)
end

return M
