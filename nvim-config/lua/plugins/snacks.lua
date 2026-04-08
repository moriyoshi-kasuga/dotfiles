return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    zen = { enabled = true },
    words = { enabled = true },

    notifier = { enabled = false },
    explorer = { enabled = false },
    picker = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
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
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
      mode = { "n", "v" },
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<c-/>",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
    {
      "[w",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Previous word",
    },
    {
      "]w",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next word",
    },
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>wm",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Toggle Zoom",
    },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
}
