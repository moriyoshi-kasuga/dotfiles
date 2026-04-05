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
        desc = "rename",
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
