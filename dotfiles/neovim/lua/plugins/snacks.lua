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
    gh = {
      enabled = true,
    },
    indent = {
      enabled = true,
      animate = {
        enabled = false,
      },
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
    bigfile = {
      enabled = true,
    },
  },
  keys = {
    {
      ",",
      enable = false,
    },
    {
      ",<cr>",
      function()
        Snacks.picker.pick()
      end,
      desc = "Pick",
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
        Snacks.picker.grep_word({
          hidden = true,
        })
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
      ",e",
      function()
        Snacks.picker({
          finder = "proc",
          cmd = "fd",
          args = { "-H", "-E", ".git", "-t", "d" },
          confirm = function(picker, item)
            picker:close()
            if item then
              require("oil").open(item.file)
            end
          end,
          transform = function(item)
            item.file = item.text
          end,
        })
      end,
      desc = "Open Folder by Oil",
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
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit Log",
    },
    {
      "<leader>gk",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit Log File",
    },
    {
      "<leader>gi",
      function()
        Snacks.picker.gh_issue()
      end,
      desc = "GitHub Issues (open)",
    },
    {
      "<leader>gI",
      function()
        Snacks.picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issues (all)",
    },
    {
      "<leader>gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>gP",
      function()
        Snacks.picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub Pull Requests (all)",
    },
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git Status"
    },
  },
}
