return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
      {
        filter = {
          any = {
            { find = "%d+L, %d+B" },
            { find = "No information available" },
          },
        },
        opts = {
          skip = true,
        },
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },
  },
  keys = {
    {
      "<S-Enter>",
      function()
        require("noice").redirect(vim.fn.getcmdline())
      end,
      mode = "c",
      desc = "Redirect Cmdline",
    },
    {
      "<leader>nl",
      function()
        require("noice").cmd("last")
      end,
      desc = "Noice Last Message",
    },
    {
      "<leader>nh",
      function()
        require("noice").cmd("history")
      end,
      desc = "Noice History",
    },
    {
      "<leader>na",
      function()
        require("noice").cmd("all")
      end,
      desc = "Noice All",
    },
    {
      "<leader>nd",
      function()
        require("noice").cmd("dismiss")
      end,
      desc = "Dismiss All",
    },
  },
}
