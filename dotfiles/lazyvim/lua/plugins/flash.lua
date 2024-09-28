return {
  "folke/flash.nvim",
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
    -- disable the default flash keymap
    { "s", mode = { "o" }, false },
    { "S", mode = { "n", "x", "o" }, false },
  },
}
