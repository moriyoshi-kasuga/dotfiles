return {
  "rapan931/lasterisk.nvim",
  lazy = true,
  keys = {
    {
      mode = "n",
      "*",
      function()
        require("lasterisk").search()
        require("hlslens").start()
      end,
    },
    {
      mode = "n",
      "g*",
      function()
        require("lasterisk").search({ is_whole = false, silent = true })
        require("hlslens").start()
      end,
    },
    {
      mode = "x",
      "g*",
      function()
        require("lasterisk").search({ is_whole = false, silent = true })
        require("hlslens").start()
      end,
    },
  },
}
