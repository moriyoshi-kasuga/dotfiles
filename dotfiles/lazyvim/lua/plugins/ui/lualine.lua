return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      globalstatus = true,
    },
  },
  -- NOTE: not use opts because not use lazyvim config. override all
  config = function()
    local lualine = require("lualine")
    lualine.setup({
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              local reg = vim.fn.reg_recording()
              if reg ~= "" then
                return "Recording @" .. reg
              end
              return str
            end,
          },
        },
        lualine_b = { "branch" },
        lualine_c = {
          LazyVim.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = LazyVim.config.icons.diagnostics.Error,
              warn = LazyVim.config.icons.diagnostics.Warn,
              info = LazyVim.config.icons.diagnostics.Info,
              hint = LazyVim.config.icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { LazyVim.lualine.pretty_path({ length = 10 }) },
        },
        lualine_x = {},
        -- ref: https://github.com/LazyVim/LazyVim/blob/25abbf546d564dc484cf903804661ba12de45507/lua/lazyvim/plugins/extras/ai/copilot.lua#L42
        lualine_y = {
          LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
            local clients = package.loaded["copilot"] and LazyVim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
            if #clients > 0 then
              local status = require("copilot.status").data.status
              return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
            end
          end),
        },
        lualine_z = {},
      },
      extensions = { "neo-tree", "lazy" },
    })
  end,
}
