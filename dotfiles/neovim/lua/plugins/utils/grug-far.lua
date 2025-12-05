return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "x" },
      desc = "Search and Replace",
    },
    {
      "<leader>br",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Open grug-far on current file",
    },
  },
  opts = {
    headerMaxWidth = 80,
    windowCreationCommand = "vsplit | wincmd L",
    keymaps = {
      openNextLocation = { n = "<C-n>" },
      openPrevLocation = { n = "<C-p>" },
    },
  },
}
