return {
  {
    "stevearc/oil.nvim",
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      lsp_file_methods = {
        enabled = true,
        autosave_changes = true,
        timeout_ms = 1000,
      },
    },
    keys = {
      { "<leader>e", "<cmd>Oil<CR>" },
    },
  },
}
