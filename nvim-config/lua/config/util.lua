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

return M
