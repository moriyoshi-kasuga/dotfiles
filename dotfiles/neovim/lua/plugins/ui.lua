if require("config.util").is_in_simple_mode() then
  return {}
end

return {
  {
    "folke/noice.nvim",
    event = "UIEnter",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
          ["vim.lsp.util.stylize_markdown"] = false,
          ["cmp.entry.get_documentation"] = false, -- requires hrsh7th/nvim-cmp
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>snd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<leader>snt",
        function()
          require("noice").cmd("pick")
        end,
        desc = "Noice Picker",
      },
    },
  },
  {
    "echasnovski/mini.icons",
    config = function(_, opts)
      require("mini.icons").setup(opts)
      -- mock nvim-web-devicons to use mini.icons instead
      require("mini.icons").mock_nvim_web_devicons()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",
    dependencies = {
      "echasnovski/mini.icons",
    },
    opts = {
      extensions = { "fzf", "oil" },
      sections = {
        -- ref: https://github.com/nvim-lualine/lualine.nvim/issues/1355#issuecomment-2566497849
        lualine_a = {
          function()
            local reg = vim.fn.reg_recording()
            -- If a macro is being recorded, show "Recording @<register>"
            if reg ~= "" then
              return "Recording @" .. reg
            else
              -- Get the full mode name using nvim_get_mode()
              local mode = vim.api.nvim_get_mode().mode
              local mode_map = {
                n = "NORMAL",
                i = "INSERT",
                v = "VISUAL",
                V = "V-LINE",
                ["^V"] = "V-BLOCK",
                c = "COMMAND",
                R = "REPLACE",
                s = "SELECT",
                S = "S-LINE",
                ["^S"] = "S-BLOCK",
                t = "TERMINAL",
              }

              -- Return the full mode name
              return mode_map[mode] or mode:upper()
            end
          end,
        },
        lualine_b = { "branch", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "searchcount", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
