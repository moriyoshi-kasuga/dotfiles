return {
  "hedyhli/outline.nvim",
  keys = {
    { "<leader>cs", false },
    { "gs", "<cmd>Outline<cr>", desc = "Toggle Outline" },
  },
  opts = {
    keymaps = {
      up_and_jump = "<C-p>",
      down_and_jump = "<C-n>",
    },
    symbols = {
      filter = {
        ---@diagnostic disable-next-line: param-type-mismatch
        rust = vim.list_extend(vim.deepcopy(LazyVim.config.kind_filter["default"]), { "Object" }),
      },
    },
  },
}
