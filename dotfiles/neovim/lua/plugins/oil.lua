return {
  {
    "stevearc/oil.nvim",
    dependencies = { { "nvim-mini/mini.icons", lazy = true, opts = {} } },
    cmd = { "Oil" },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      lsp_file_methods = {
        enabled = true,
        autosave_changes = true,
        timeout_ms = 1000,
      },
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",
        ["<C-/>"] = {
          function()
            local _, oil_dir = pcall(require("oil").get_current_dir)
            if not oil_dir then
              vim.notify("failed to get oil dir", 2)
              return
            end
            require("config.terminal").toggle(oil_dir)
          end,
          mode = "n",
          nowait = true,
          desc = "Open Terminal",
        },
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
      },
      use_default_keymaps = false,
    },
    keys = {
      { "<leader>e", "<cmd>Oil<CR>", desc = "Open Oil file browser" },
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
    },
  },
}
