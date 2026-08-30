---@type LazySpec[]
-- Filetypes prettier can format without any project-specific plugin.
local prettier_filetypes = {
  "css",
  "scss",
  "less",
  "html",
  "json",
  "jsonc",
  "yaml",
  "markdown",
  "markdown.mdx",
  "graphql",
  "handlebars",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

-- svelte/astro are only supported by prettier through a project-installed
-- plugin (prettier-plugin-svelte / prettier-plugin-astro); `has_parser` below
-- asks prettier itself whether it can infer a parser instead of assuming yes.
---@param ctx {buf: number, filename: string, dirname: string}
local function has_parser(ctx)
  -- Resolves the same binary conform itself will invoke (project-local
  -- node_modules/.bin/prettier if present, else the one on PATH). Required
  -- lazily: at spec-load time conform.nvim isn't on the runtimepath yet.
  local cmd = require("conform.util").from_node_modules("prettier")(nil, ctx)
  if vim.fn.executable(cmd) ~= 1 then
    return false
  end
  local ft = vim.bo[ctx.buf].filetype
  if vim.tbl_contains(prettier_filetypes, ft) then
    return true
  end
  local result = vim.fn.system({ cmd, "--file-info", ctx.filename })
  local ok, decoded = pcall(vim.fn.json_decode, result)
  return ok and decoded.inferredParser ~= vim.NIL
end

return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>r",
        function()
          require("conform").format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 2000,
          })
        end,
        mode = { "n", "v" },
        desc = "Format buffer or selection",
      },
    },
    opts = {
      -- Configure formatters by filetype
      -- Note: All formatters should be installed via Nix
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
        nix = { "nixfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        python = { "ruff_format" },
        java = { "spotless_gradle" },

        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        graphql = { "prettier" },
        handlebars = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        astro = { "prettier" },
      },

      formatters = {
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        prettier = {
          condition = function(_, ctx)
            return has_parser(ctx)
          end,
        },
      },

      -- 不要のため無効化
      format_on_save = false,
      format_after_save = false,
    },
  },
}
