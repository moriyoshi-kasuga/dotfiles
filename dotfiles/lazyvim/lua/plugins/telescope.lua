local actions = require("telescope.actions")

local function filename_first(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then
    return tail
  end
  return string.format("%s\t%s", tail, parent)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    keys = {
      { "<leader>*", "<cmd>Telescope grep_string<cr>", desc = "Grep String", mode = { "n", "v" } },
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
        mode = { "n", "v" },
      },
      {
        "<leader><space>",
        "<cmd>Telescope find_files<cr>",
        desc = "Find Files",
      },
      {
        "<leader>s<space>",
        function()
          require("telescope.builtin").find_files({
            find_command = { "fd", "--hidden", "--type", "f", "--follow" },
          })
        end,
        desc = "Find Files (include hidden file)",
      },
    },
    opts = {
      defaults = {
        path_display = filename_first,
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
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("ui-select")
    end,
  },
  {
    "prochri/telescope-all-recent.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "kkharji/sqlite.lua",
      -- optional, if using telescope for vim.ui.select
      "stevearc/dressing.nvim",
    },
    config = function()
      require("telescope-all-recent").setup({})
    end,
    opts = {
      -- your config goes here
    },
  },
}
