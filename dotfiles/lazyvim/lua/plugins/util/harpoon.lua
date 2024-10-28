return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = {
    {
      "<leader>n",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon File",
    },
    {
      "<leader>N",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon Quick Menu",
    },
    {
      "<C-n>",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon Select 1",
    },
    {
      "<C-p>",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon Select 2",
    },
    {
      "<C-s>",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon Select 3",
    },
    {
      "<C-m>",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon Select 4",
    },
  },
}
