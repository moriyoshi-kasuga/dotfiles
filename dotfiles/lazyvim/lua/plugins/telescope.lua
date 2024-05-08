local actions = require("telescope.actions")

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>*", "<cmd>Telescope grep_string<cr>", desc = "Grep String" },
      {
        "<leader>s/",
        function()
          require("telescope.builtin").live_grep({
            additional_args = { "--hidden" },
          })
        end,
        desc = "Live Grep (include hidden file)",
      },
      {
        "<leader>s*",
        function()
          require("telescope.builtin").grep_string({
            additional_args = { "--hidden" },
          })
        end,
        desc = "Live Grep (include hidden file)",
      },
      { "<leader>*", "<cmd>Telescope grep_string<cr>", desc = "Grep String" },
      {
        "<leader>s/",
        function()
          require("telescope.builtin").live_grep({
            additional_args = { "--hidden" },
          })
        end,
        desc = "Live Grep (include hidden file)",
      },
      {
        "<leader>s*",
        function()
          require("telescope.builtin").grep_string({
            additional_args = { "--hidden" },
          })
        end,
        desc = "Live Grep (include hidden file)",
      },
    },
    opts = {
      defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        mappings = {
          i = {
            ["<C-i>"] = require("telescope.actions.layout").toggle_preview,
            ["<C-j>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
          },
        },
        file_ignore_patterns = {
          "node_modules",
        },
        pickers = {
          find_files = {
            hidden = false,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      },
    },
  },
  {
    "prochri/telescope-all-recent.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "kkharji/sqlite.lua",
      -- optional, if using telescope for vim.ui.select
      "stevearc/dressing.nvim",
    },
    opts = {
      -- your config goes here
    },
  },
}
