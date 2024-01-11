return {
  "FotiadisM/tabset.nvim",
  lazy = false,
  config = function()
    require("tabset").setup({
      defaults = {
        tabwidth = 4,
        expandtab = true,
      },
      languages = {
        {
          filetypes = {
            "make",
          },
          config = {
            tabwidth = 8,
            expandtab = false,
          },
        },
        {
          filetypes = {
            "css",
            "sccs",
            "markdown",
            "markdown.mdx",
            "graphql",
            "handlebars",
            "vue",
            "less",
            "java",
            "class",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "json",
            "jsonc",
            "html",
            "htmldjango",
            "lua",
            "kotlin",
            "yaml",
            "yml",
          },
          config = {
            tabwidth = 2,
          },
        },
        {
          filetype = { "python" },
          config = {
            tabwidth = 4,
          },
        },
      },
    })
  end,
}
