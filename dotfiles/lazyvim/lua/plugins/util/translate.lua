return {
  "uga-rosa/translate.nvim",
  lazy = false,
  opts = {
    preset = {
      output = {
        split = {
          append = true,
        },
      },
    },
  },
  keys = {
    { "<leader>Te", mode = { "n", "v" }, "<cmd>Translate en<cr>", desc = "Translate English" },
    { "<leader>Tj", mode = { "n", "v" }, "<cmd>Translate ja<cr>", desc = "Translate Japanese" },
    {
      "<leader>TE",
      mode = { "n", "v" },
      "<cmd>Translate en -output=replace<cr>",
      desc = "translate to en of replace",
    },
    {
      "<leader>TJ",
      mode = { "n", "v" },
      "<cmd>Translate ja -output=replace<cr>",
      desc = "translate to ja of replace",
    },
  },
}
