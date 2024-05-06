return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
  },
  config = function()
    require("neoclip").setup()
    vim.keymap.set("n", "<leader>p", "<cmd>Telescope neoclip<CR>", { desc = "Telescope Neoclip" })
  end,
}
