
return {
  "ThePrimeagen/harpoon",
  lazy = false,
  opts = {},
  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")
    require("which-key").register({
      ["<leader>l"] = { mark.add_file, "Add harpoon file" },
      ["<C-e>"] = { ui.toggle_quick_menu, "Toggle harpoon menu" },
      ["<C-n>"] = { function() ui.nav_file(1) end, "Nav harpoon 1" },
      ["<C-p>"] = { function() ui.nav_file(2) end, "Nav harpoon 2" },
      ["<C-y>"] = { function() ui.nav_file(3) end, "Nav harpoon 3" },
      ["<C-s>"] = { function() ui.nav_file(4) end, "Nav harpoon 4" },
    })
  end,
}
