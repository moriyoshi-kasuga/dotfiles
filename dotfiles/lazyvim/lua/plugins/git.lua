return {
  { "lewis6991/gitsigns.nvim", enabled = false },
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",

      "folke/snacks.nvim",
    },
    opts = {
      disable_hint = true,
      disable_signs = true,
    },
    keys = {
      { "gs", "<cmd>Neogit kind=tab<CR>", desc = "Neogit" },
      { "gS", "<cmd>Neogit kind=split<CR>", desc = "Neogit Split" },
      { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Neogit Commit" },
      { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Neogit Pull" },
      { "<leader>gP", "<cmd>Neogit push<CR>", desc = "Neogit Push" },
    },
  },
  {
    "sindrets/diffview.nvim",
    opts = function()
      local actions = require("diffview.actions")
      return {
        keymaps = {
          view = {
            { "n", "<C-n>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
            {
              "n",
              "<C-p>",
              actions.select_prev_entry,
              { desc = "Open the diff for the previous file" },
            },
          },
          file_panel = {
            {
              "n",
              "<C-n>",
              actions.select_next_entry,
              { desc = "Open the diff for the next file" },
            },
            {
              "n",
              "<C-p>",
              actions.select_prev_entry,
              { desc = "Open the diff for the previous file" },
            },
          },
        },
      }
    end,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview Open" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview File History" },
    },
  },
}
