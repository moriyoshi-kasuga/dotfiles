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

      local next = { "n", "<C-n>", actions.select_next_entry, { desc = "Open the diff for the next file" } }
      local prev = {
        "n",
        "<C-p>",
        actions.select_prev_entry,
        { desc = "Open the diff for the previous file" },
      }
      local close = { "n", "q", "<cmd>tabclose<CR>", { desc = "Close Diffview" } }
      local commit = { "n", "c", "<cmd>Neogit commit<CR>", { desc = "Neogit Commit" } }

      return {
        hooks = {
          diff_buf_read = function()
            vim.opt_local.wrap = false
            vim.opt_local.list = false
            vim.opt_local.colorcolumn = { 80 }
            vim.opt_local.signcolumn = "no"
            vim.opt_local.relativenumber = false
            vim.opt_local.number = false
          end,
        },
        keymaps = {
          view = {
            next,
            prev,
            close,
            commit,
          },
          file_panel = {
            next,
            prev,
            close,
            commit,
          },
        },
      }
    end,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview Open" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview File History" },
      { "<leader>gF", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview File History (All)" },
    },
  },
}
