local actions = require("telescope.actions")

return {
  {
    "nvim-telescope/telescope.nvim",
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
}
