return {
  "https://gitlab.com/yorickpeterse/nvim-window.git",
  event = "VeryLazy",
  config = function()
    require("nvim-window").setup({
      hint_hl = "Bold",
    })
  end,
  keys = {
    {
      "<leader>wq",
      function()
        require("nvim-window").pick()
      end,
      desc = "Move window",
    },
  },
}
