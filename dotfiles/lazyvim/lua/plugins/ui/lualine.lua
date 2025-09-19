local snacks_extension = {
  sections = {
    lualine_a = {
      function()
        return "Snacks"
      end,
    },
    lualine_z = {
      function()
        local pickers = Snacks.picker.get()
        if #pickers == 0 then
          return " No Picker"
        end
        ---@type string?
        local file = nil
        for _, p in ipairs(pickers) do
          local item = p.list:current()
          if item and item.file then
            file = item.file
            break
          end
        end
        if file then
          return " " .. file
        end
        return " Picker Open"
      end,
    },
  },
  filetypes = { "snacks_picker_input" },
}

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
        -- ref: https://github.com/LazyVim/LazyVim/blob/f4e64eea45d9aa171e057ca328f2b9459c40404a/lua/lazyvim/plugins/extras/ai/copilot.lua#L51
        lualine_y = {
          LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
            local clients = package.loaded["copilot"] and vim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
            if #clients > 0 then
              local status = require("copilot.status").data.status
              return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
            end
          end),
        },
        lualine_z = {},
      },
      extensions = { "neo-tree", "lazy", snacks_extension },
    })
  end,
}
