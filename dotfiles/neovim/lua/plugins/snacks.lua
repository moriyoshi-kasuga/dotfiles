return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = {
      enabled = true,
      animate = { enabled = false },
    },
    git = { enabled = true },
    quickfile = { enabled = true },
    scope = {
      enabled = true,
      treesitter = { enabled = false },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(event)
        if event.data.actions == nil then
          return
        end
        for _, value in ipairs(event.data.actions) do
          if value.type == "move" then
            Snacks.rename.on_rename_file(value.src_url, value.dest_url)
          end
        end
      end,
    })
  end,
  keys = {
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
    {
      "<c-/>",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
  },
}
