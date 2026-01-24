return {
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

      return {
        use_icons = false, -- required nvim-web-devicons
        show_help_hints = false,
        hooks = {
          diff_buf_read = function()
            vim.opt_local.wrap = true
          end,
        },
        keymaps = {
          view = {
            next,
            prev,
          },
          file_panel = {
            next,
            prev,
          },
        },
      }
    end,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview Open" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview File History", mode = { "n" } },
      {
        "<leader>gf",
        ":'<,'>DiffviewFileHistory<CR>",
        desc = "Diffview Range History",
        mode = { "v" },
      },
      { "<leader>gF", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview File History (All)" },
    },
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      "ibhagwan/fzf-lua",
    },
    cmd = "Neogit",
    keys = {
      { "<C-.>", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
}
