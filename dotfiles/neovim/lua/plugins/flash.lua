return  {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    modes = {
      char = {
        enabled = false,
      },
      search = {
        enabled = false,
      },
    },
  },
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "R", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "<c-space>", mode = { "n", "o", "x" },
    function()
      require("flash").treesitter({
        actions = {
          ["<c-space>"] = "next",
          ["<BS>"] = "prev"
        }
      })
    end, desc = "Treesitter Incremental Selection" },
  },
}
