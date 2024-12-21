return {
  "FotiadisM/tabset.nvim",
  event = "LazyFile",
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
            "c",
            "cs",
            "cpp",
            "css",
            "sccs",
            "markdown",
            "markdown.mdx",
            "mdx",
            "graphql",
            "handlebars",
            "vue",
            "less",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "astro",
            "json",
            "jsonc",
            "html",
            "htmldjango",
            "lua",
            "yaml",
            "yml",
            "java",
            "class",
            "kotlin",
            "scala",
            "svelte",
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
