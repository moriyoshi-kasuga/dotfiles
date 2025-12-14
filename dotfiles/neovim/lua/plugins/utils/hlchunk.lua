return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    chunk = {
      enable = true,
      duration = 50,
      delay = 100,
      textobject = "ai",
    },
    indent = {
      enable = true,
    },
  },
}
