return {
  {
    "snacks.nvim",
    opts = {
      picker = {
        formatters = {
          file = {
            truncate = 200,
          },
        },
        actions = {
          ---@param picker snacks.Picker
          list_scroll_right = function(picker)
            if picker.list.win:valid() then
              picker.list.win:hscroll()
            end
          end,
          ---@param picker snacks.Picker
          list_scroll_left = function(picker)
            if picker.list.win:valid() then
              picker.list.win:hscroll(true)
            end
          end,
        },
        win = {
          input = {
            keys = {
              ["<C-l>"] = { "list_scroll_right", mode = { "n", "i" } },
              ["<C-r>"] = { "list_scroll_left", mode = { "n", "i" } },
            },
          },
        },
      },
      image = {
        enabled = false,
      },
      dashboard = {
        preset = {
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "/", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "s", desc = "Restore Session", action = ":SessionLoad" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      terminal = {
        win = {
          keys = {
            nav_h = { "<C-h>", false },
            nav_j = { "<C-j>", false },
            nav_k = { "<C-k>", false },
            nav_l = { "<C-l>", false },
          },
        },
      },
    },
    keys = {
      {
        "<leader>go",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Open GitHub Repository",
      },
      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
    },
  },
}
