---@type LazySpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    input = {
      enabled = true,
    },
    indent = {
      enabled = true,
      indent = {
        only_current= true,
        only_scope= true,
      }
    },
    picker = {
      ui_select = true,
      formatters = {
        file = {
          filename_first = true,
          truncate = 400,
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
    },
    dashboard = {
      enabled = true,
      preset = {
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "/", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
    bigfile = {
      enabled = true,
    },
  },
  keys = {
    {
      "s",
      enable = false,
    },
    {
      ",",
      enable = false,
    },
    {
      ",<cr>",
      function()
        Snacks.picker.picker_actions()
      end,
      desc = "Picker Actions",
    },
    {
      ",g",
      function()
        Snacks.picker.grep({
          hidden = true,
        })
      end,
      desc = "Grep",
    },
    {
      ",B",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Grep Buffers",
    },
    {
      ",w",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Grep String",
      mode = { "n", "x" },
    },
    {
      ",b",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      ",c",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorscheme",
    },
    {
      ",s",
      function()
        Snacks.picker.files({
          hidden = true,
        })
      end,
      desc = "Find Files",
    },
    {
      ",h",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Pages",
    },
    {
      ",j",
      function()
        Snacks.picker.jumps()
      end,
      desc = "Jumplist",
    },
    {
      ",l",
      function()
        Snacks.picker.lazy()
      end,
      desc = "Lazy",
    },
    {
      ",m",
      function()
        Snacks.picker.marks()
      end,
      desc = "Marks",
    },
    {
      ",p",
      function()
        Snacks.picker.commands()
      end,
      desc = "Commands",
    },
    {
      ",q",
      function()
        Snacks.picker.qflist()
      end,
      desc = "qflist",
    },
    {
      ",r",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
    },
    {
      ",d",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
    },
    {
      ",D",
      function()
        Snacks.picker.diagnostics()
      end,
    },
    {
      "<leader>d",
      function()
        if Snacks.dim.enabled then
          Snacks.dim.disable()
        else
          Snacks.dim.enable()
        end
      end,
      desc = "Dim",
    },
  },
}
