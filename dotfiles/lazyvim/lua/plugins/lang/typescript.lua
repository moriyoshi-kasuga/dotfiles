return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            javascript = {
              format = false,
            },
            typescript = {
              format = false,
            },
          },
        },
      },
    },
  },
}
