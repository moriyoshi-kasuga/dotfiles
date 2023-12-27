return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "black",
        "prettier",
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "bash-language-server",
        "hadolint",
        "flake8",
        "djlint",
      })
    end,
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
    },
  },

  -- formatters
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["htmldjango"] = { "djlint" },
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "js-everts/cmp-tailwind-colors", opts = {} },
    },
    opts = function(_, opts)
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        if item.kind == "Color" then
          item = require("cmp-tailwind-colors").format(entry, item)
          if item.kind == "Color" then
            return format_kinds(entry, item)
          end
          return item
        end
        return format_kinds(entry, item)
      end
    end,
  },
}
