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
    { "s", mode = { "o", "v", "x" }, false },
    { "S", mode = { "n", "x", "o", "v" }, false },
  },
}
