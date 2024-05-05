return {
  {
    "hedyhli/outline.nvim",
    lazy = false;
    config = function()
      vim.keymap.set("n", "<leader>cs", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
      require("outline").setup({})
    end,
  },
}
