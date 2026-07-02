return {
  "leath-dub/snipe.nvim",
  opts = {
    ui = {
      position = "center",
    },
    navigate = {
      cancel_snipe = "q",
    },
  },
  keys = {
    {
      ",a",
      function()
        require("snipe").open_buffer_menu()
      end,
      desc = "Open Snipe buffer menu",
    },
  },
}
