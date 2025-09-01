return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes = { "rust" },
          settings = {
            tailwindCSS = {
              includeLanguages = {
                rust = "html",
              },
              experimental = {
                classRegex = {
                  'class\\s*:\\s*"([^"]*)',
                },
              },
            },
          },
        },
      },
    },
  },
}
