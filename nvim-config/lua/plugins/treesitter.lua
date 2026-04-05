return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "VeryLazy", "BufReadPost", "BufNewFile", "BufWritePre" },
    branch = "main",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if args.file == "markdown" or args.file == "markdown_inline" then
            return
          end
          -- ignore error
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "main",
    opts = {
      move = {
        set_jumps = true,
      },
    },
    keys = {
      -- Text object selections
      {
        "af",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select outer function",
      },
      {
        "if",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select inner function",
      },
      {
        "ac",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select outer class",
      },
      {
        "ic",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select inner class",
      },
      {
        "aa",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select outer parameter",
      },
      {
        "ia",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select inner parameter",
      },

      -- Move to next start
      {
        "]f",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next function start",
      },
      {
        "]c",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next class start",
      },
      {
        "]a",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next parameter start",
      },

      -- Move to next end
      {
        "]F",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next function end",
      },
      {
        "]C",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next class end",
      },
      {
        "]A",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.inner", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next parameter end",
      },

      -- Move to previous start
      {
        "[f",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Previous function start",
      },
      {
        "[c",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Previous class start",
      },
      {
        "[a",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Previous parameter start",
      },

      -- Move to previous end
      {
        "[F",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Previous function end",
      },
      {
        "[C",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Previous class end",
      },
      {
        "[A",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.inner", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Previous parameter end",
      },
    },
  },
  {
    "andersevenrud/nvim_context_vt",
    event = "LspAttach",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      disable_virtual_lines = true,
      disable_ft = {
        "markdown",
        "markdown_inline",
        "yaml",
        "toml",
      },
    },
  },
}
