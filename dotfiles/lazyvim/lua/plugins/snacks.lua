return {
  {
    "snacks.nvim",
    opts = {
      picker = {
        -- Disable auto-loading of picker config modules at startup
        preload = false,
        formatters = {
          file = {
            truncate = 200,
            filename_first = true,
          },
        },
        layout = {
          layout = {
            backdrop = false,
            width = 0.7,
            min_width = 80,
            height = 0.8,
            min_height = 30,
            box = "vertical",
            border = "rounded",
            title = "{title} {live} {flags}",
            title_pos = "center",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
            { win = "preview", title = "{preview}", height = 0.6, border = "top" },
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
      {
        "<leader>,",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      { "<leader>/", LazyVim.pick("grep", { root = false, hidden = true }), desc = "Grep (Cwd)" },
      { "<leader><space>", LazyVim.pick("files", { root = false, hidden = true }), desc = "Find Files (Cwd)" },
      { "<leader>ff", LazyVim.pick("files", { hidden = true }), desc = "Find Files (Root Dir)" },
      { "<leader>fF", LazyVim.pick("files", { root = false, hidden = true }), desc = "Find Files (cwd)" },
    },
  },
}
