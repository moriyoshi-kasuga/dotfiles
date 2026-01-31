return {
  "folke/flash.nvim",
  ---@type Flash.Config
  opts = {
    modes = {
      jump = {
        enabled = false,
      },
      char = {
        enabled = false,
      },
      search = {
        enabled = false,
      },
    },
  },
  keys = {
    {
      "R",
      mode = { "n", "o", "x" },
      function()
        require("flash").remote()
      end,
      desc = "Flash Remote",
    },
    {
      "<c-space>",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter({
          actions = {
            ["<c-space>"] = "next",
            ["<BS>"] = "prev",
          },
        })
      end,
      desc = "Treesitter Incremental Selection",
    },
  },
}
