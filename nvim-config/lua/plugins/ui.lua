if require("config.util").is_in_simple_mode() then
  return {}
end

return {
  {
    "saecki/live-rename.nvim",
    keys = {
      {
        "<leader>cr",
        function()
          require("live-rename").rename()
        end,
        desc = "Rename",
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    event = "UIEnter",
    opts = {
      notification = { override_vim_notify = true },
      progress = {
        ignore = {
          function(msg)
            if msg == nil or msg.title == nil then
              return false
            end
            return msg.lsp_client.name == "metals" and string.find(msg.title, "Compiling ")
          end,
        },
      },
    },
    keys = {
      {
        "<leader>sna",
        "<cmd>Fidget history<cr>",
        desc = "Notification History",
      },
      {
        "<leader>snd",
        "<cmd>Fidget clear<cr>",
        desc = "Dismiss All Notification",
      },
    },
  },
  {
    "nvim-mini/mini.icons",
    opts = {},
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",
    dependencies = {
      "nvim-mini/mini.icons",
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
        lualine_c = {
          {
            "filename",
            path = 1, -- relative to current working directory (:cd)
          },
        },
        lualine_x = { "searchcount", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
