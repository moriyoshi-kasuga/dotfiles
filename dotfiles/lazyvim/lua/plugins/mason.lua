return {
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
      "java-test",
      "java-debug-adapter",
    })
  end,
  keys = {
    { "<leader>cm", false },
  },
}
