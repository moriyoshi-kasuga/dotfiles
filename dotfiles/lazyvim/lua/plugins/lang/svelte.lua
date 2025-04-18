return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svelte = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = false,
              },
            },
          },
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
