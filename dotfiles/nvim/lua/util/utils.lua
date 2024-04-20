local M = {}

function M.cmd(command)
  return table.concat({ "<cmd>", command, "<cr>" })
end

function M.on_attach(attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      attach(client, buffer)
    end,
  })
end

return M
