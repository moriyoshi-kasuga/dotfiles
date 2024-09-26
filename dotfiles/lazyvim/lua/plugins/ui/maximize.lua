return {
  "declancm/maximize.nvim",
  config = true,
  event = { "LazyFile", "VeryLazy" },
  keys = {
    { "<leader>wv", "<C-w>v", desc = "Vertical split" },
    { "<leader>ws", "<C-w>s", desc = "Horizontal split" },
    { "<leader>wo", "<C-w>o", desc = "Close Other window" },
    {
      "<leader>wz",
      function()
        require("maximize").toggle()
      end,
      desc = "Maximize",
    },
  },
}
