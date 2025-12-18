return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    {
      "<leader>j",
      function()
        require("treesj").toggle()
      end,
      desc = "Toggle split",
    },
    {
      "<leader>J",
      function()
        require("treesj").toggle({ split = { recursive = true } })
      end,
      desc = "Toggle split (recursive)",
    },
  },
  opts = {
    use_default_keymaps = false,
    max_join_length = 1200,
  },
}
