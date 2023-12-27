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
            "java",
            "class",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "json",
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
