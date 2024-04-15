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
    { "<leader>te", mode = { "n", "v" }, "<cmd>Translate en<cr>", desc = "Translate English" },
    { "<leader>tj", mode = { "n", "v" }, "<cmd>Translate ja<cr>", desc = "Translate Japanese" },
    {
      "<leader>tE",
      mode = { "n", "v" },
      "<cmd>Translate en -output=replace<cr>",
      desc = "translate to en of replace",
    },
    {
      "<leader>tJ",
      mode = { "n", "v" },
      "<cmd>Translate ja -output=replace<cr>",
      desc = "translate to ja of replace",
    },
  },
}
