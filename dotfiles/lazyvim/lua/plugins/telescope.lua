local actions = require("telescope.actions")

local max = 20

local function filename_first(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then
    return tail
  end

  local iter = vim.iter(vim.split(parent, "/", { trimempty = true, plain = true })):rev()
  local result = iter:next()
  if result == nil then
    return string.format("%s %s", tail, parent)
  end
  local dir = iter:next()
  while dir ~= nil do
    if string.len(dir .. "/" .. result) > max then
      break
    end
    result = dir .. "/" .. result
    dir = iter:next()
  end
  return string.format("%s %s", tail, result)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>*", "<cmd>Telescope grep_string<cr>", desc = "Grep String", mode = { "n", "v" } },
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
        "<leader>/",
        function()
          require("telescope.builtin").grep_string({
            word_match = "-w",
            only_sort_text = true,
            search = "",
          })
        end,
        desc = "Live Grep (include hidden file)",
      },
      {
        "<leader>s/",
        function()
          require("telescope.builtin").grep_string({
            additional_args = { "--hidden" },
            word_match = "-w",
            only_sort_text = true,
            search = "",
          })
        end,
        desc = "Live Grep (include hidden file)",
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
        },
      },
    },
  },
}
