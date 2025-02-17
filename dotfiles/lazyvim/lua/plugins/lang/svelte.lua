return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svelte = {
          settings = {
            svelte = {
              plugin = {
                svelte = {
                  format = false,
                },
              },
            },
          },
        },
      },
    },
  },
}
