return {
  "moriyoshi-kasuga/google-translate.nvim",
  lazy = false,
  opts = {
    target = "ja",
    float = {
      height = 0.85,
      width = 0.75,
      -- Border as in nvim_open_win(). Uses 'winborder' when nil.
      border = nil,
    },
  },
  keys = {
    {
      "<leader>k",
      ":Translate --float<CR>",
      mode = "x",
      desc = "Translate show on float",
    },
    {
      "<leader>K",
      ":Translate<CR>",
      mode = "x",
      desc = "Translate with replace",
    },
  },
}
