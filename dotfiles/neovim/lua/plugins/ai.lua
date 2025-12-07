return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  version = "v17.33.0",
  opts = {
    ignore_warnings = true,
    opts = {
      log_level = "DEBUG",
      language = "Japanese",
    },
    strategies = {
      chat = {
        adapter = "copilot",
        model = "claude-4.5-sonnet",
      },
      inline = {
        adapter = "copilot",
        model = "claude-4.5-sonnet",
      },
    },
    display = {
      chat = {
        auto_scroll = false,
        show_header_separator = true,
      },
    },
  },
  keys = {
    {
      "<leader>aa",
      ":CodeCompanion<CR>",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<leader>ac",
      ":CodeCompanionChat<CR>",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<leader>ap",
      ":CodeCompanionAction<CR>",
      mode = { "n", "v" },
      silent = true,
    },
  },
}
