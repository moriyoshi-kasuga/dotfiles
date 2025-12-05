return {
  "stevearc/aerial.nvim",
  opts = {},
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-mini/mini.icons",
  },
  keys = {
    {
      "go",
      "<cmd>AerialToggle!<CR>",
      desc = "Show Aerial",
    },
  },
}
