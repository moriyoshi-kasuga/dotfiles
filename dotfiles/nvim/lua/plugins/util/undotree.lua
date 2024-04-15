return {
  --undotree
  "mbbill/undotree",
  event = "BufEnter",
  keys = {
    { "<leader>i", "<cmd>UndotreeToggle<cr>", desc = "Undotree" },
  },
}
