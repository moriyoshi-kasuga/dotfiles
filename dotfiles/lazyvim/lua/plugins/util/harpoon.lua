return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = function()
    local harpoon = require("harpoon")
    local keys = {
      {
        "m",
        function()
          harpoon:list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "M",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
      {
        "H",
        function()
          harpoon:list():prev()
        end,
        desc = "Harpoon Previous File",
      },
      {
        "L",
        function()
          harpoon:list():next()
        end,
        desc = "Harpoon Next File",
      },
    }

    return keys
  end,
}