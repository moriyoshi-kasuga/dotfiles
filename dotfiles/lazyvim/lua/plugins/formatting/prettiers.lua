local M = {}

local supported = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

---@param ctx ConformCtx
function M.has_config(ctx)
  vim.fn.system({ "prettierd", "--find-config-path", ctx.filename })
  return vim.v.shell_error == 0
end

function M.has_parser(ctx)
  local ft = vim.bo[ctx.buf].filetype --[[@as string]]
  if vim.tbl_contains(supported, ft) then
    return true
  end
  local ret = vim.fn.system({ "prettierd", "--file-info", ctx.filename })
  local ok, parser = pcall(function()
    return vim.fn.json_decode(ret).inferredParser
  end)
  return ok and parser and parser ~= vim.NIL
end

M.has_config = LazyVim.memoize(M.has_config)
M.has_parser = LazyVim.memoize(M.has_parser)

return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "prettierd" } },
  },

  -- conform
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = { "prettierd" }
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.prettierd = {
        condition = function(_, ctx)
          return M.has_parser(ctx) and M.has_config(ctx)
        end,
      }
    end,
  },

  -- none-ls support
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.prettierd)
    end,
  },
}
