return {
  "aznhe21/actions-preview.nvim",
  lazy = true,
  keys = {
    {
      "ga",
      function()
        require("actions-preview").code_actions()
      end,
      desc = "Code Action",
      mode = { "n", "v" },
    },
  },
}
