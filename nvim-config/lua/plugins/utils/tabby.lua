return {
  "nanozuki/tabby.nvim",
  dependencies = {
    "echasnovski/mini.icons",
  },
  event = "VeryLazy",
  config = function()
    local palette = require("catppuccin.palettes").get_palette("macchiato")

    local theme = {
      fill   = { fg = palette.surface2, bg = "none" },
      active = { fg = palette.mauve, bg = palette.surface0, style = "bold" },
      normal = { fg = palette.overlay1, bg = "none" },
    }

    require("tabby").setup({
      line = function(line)
        return {
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.active or theme.normal
            return {
              " ",
              tab.number(),
              " ",
              tab.name(),
              tab.close_btn(" "),
              " ",
              hl = hl,
            }
          end),
          line.spacer(),
          hl = theme.fill,
        }
      end,
    })
  end,
}
