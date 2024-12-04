return {
  "MagicDuck/grug-far.nvim",
  keys = {
    {
      "<leader>br",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Open grug-far on current file",
    },
  },
}
