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
  opts = {
    highlight_command = {
      function()
        return require("actions-preview.highlight").delta("delta --diff-so-fancy")
      end,
    },
    backend = { "snacks" },
  },
}
