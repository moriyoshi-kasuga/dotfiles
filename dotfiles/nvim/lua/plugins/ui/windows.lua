local cmd = require("util.utils").cmd
return {
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
    },
    config = function()
      require("windows").setup()
      require("which-key").register({
        ["<leader>w"] = {
          name = "+window",
          v = { "<C-w>v", "Vertical split" },
          s = { "<C-w>s", "Horizontal split" },
          o = { "<C-w>o", "Close Other window" },
          w = { "<C-w>w", "Switch Window" },
          S = { cmd("WindowsMaximizeHorizontally"), "Horizontal Zoom" },
          V = { cmd("WindowsMaximizeVertically"), "Vertical Zoom" },
          e = { cmd("WindowsEqualize"), "Equalize Zoom" },
          z = { cmd("WindowsMaximize"), "Maxmize" },
        },
      })
    end,
  },
  {
    "yorickpeterse/nvim-window",
    keys = {
      { "<leader>wq", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
    },
    config = true,
  },
}
