return {
  "gbprod/yanky.nvim",
  event = "VeryLazy",
  opts = {
    system_clipboard = {
      sync_with_ring = not vim.env.SSH_CONNECTION,
    },
    highlight = { timer = 150 },
  },
  keys = {
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put after and leave cursor" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before and leave cursor" },
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before" },
    { "<leader>p", "<cmd>YankyRingHistory<cr>", desc = "Yank History" },
  },
}
