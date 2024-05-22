return {
  "anuvyklack/windows.nvim",
  dependencies = {
    "anuvyklack/middleclass",
  },
  config = function()
    require("windows").setup()
  end,
  keys = {
    { "<leader>wv", "<C-w>v", desc = "Vertical split" },
    { "<leader>ws", "<C-w>s", desc = "Horizontal split" },
    { "<leader>wo", "<C-w>o", desc = "Close Other window" },
    { "<leader>wS", "<cmd>WindowsMaximizeHorizontally<cr>", desc = "Horizontal Zoom" },
    { "<leader>wV", "<cmd>WindowsMaximizeVertically<cr>", desc = "Vertical Zoom" },
    { "<leader>we", "<cmd>WindowsEqualize<cr>", desc = "Equalize Zoom" },
    { "<leader>wz", "<cmd>WindowsMaximize<cr>", desc = "Maximize" },
  },
}
