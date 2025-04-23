return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svelte = {
          on_attach = function(client, _)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              callback = function(ctx)
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
              end,
            })
          end,
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
