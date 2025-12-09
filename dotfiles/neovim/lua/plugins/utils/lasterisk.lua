return {
  "rapan931/lasterisk.nvim",
  lazy = true,
  keys = {
    {
      mode = "n",
      "*",
      function()
        require("lasterisk").search()
      end,
    },
    {
      mode = "n",
      "g*",
      function()
        require("lasterisk").search({ is_whole = false })
      end,
    },
    {
      mode = "x",
      "g*",
      function()
        require("lasterisk").search({ is_whole = false })
      end,
    },
  },
}
