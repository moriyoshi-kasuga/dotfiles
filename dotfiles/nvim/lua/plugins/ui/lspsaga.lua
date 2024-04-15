return {
  "nvimdev/lspsaga.nvim",
  lazy = false,
  config = function()
    require("lspsaga").setup({ lightbulb = { enable = false } })
  end,
  keys = {
    { "gs", "<cmd>Lspsaga outline<cr>", desc = "Show Outlines" },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-tree/nvim-web-devicons",     -- optional
  },
}
