return {
  "nanozuki/tabby.nvim",
  dependencies = {
    "nvim-mini/mini.icons",
  },
  event = "VeryLazy",
  config = function()
    -- 引数なしだと読み込み済みの catppuccin の flavour を使う
    local palette = require("catppuccin.palettes").get_palette()

    local theme = {
      fill = { fg = palette.surface2, bg = "none" },
      active = { fg = palette.mauve, bg = palette.surface0, style = "bold" },
      normal = { fg = palette.overlay1, bg = "none" },
    }

    -- the tab-local cwd (:tcd) tells tabs apart when they show the same file
    local function tab_name(tabid)
      local api = require("tabby.module.api")
      local cur_win = api.get_tab_current_win(tabid)
      -- kiln names its views after the repository path, so name them after the filetype
      local ft = vim.bo[vim.api.nvim_win_get_buf(cur_win)].filetype
      local name
      if ft:find("^kiln") then
        name = "kiln " .. ft:sub(5)
      elseif api.is_float_win(cur_win) then
        name = "[Floating]"
      else
        name = require("tabby.feature.win_name").get(cur_win)
      end
      local tabnr = vim.api.nvim_tabpage_get_number(tabid)
      if vim.fn.haslocaldir(-1, tabnr) == 1 then
        name = vim.fs.basename(vim.fn.getcwd(-1, tabnr)) .. ": " .. name
      end
      return name
    end

    require("tabby").setup({
      option = {
        tab_name = { name_fallback = tab_name },
      },
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
