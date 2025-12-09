return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "VeryLazy", "BufReadPost", "BufNewFile", "BufWritePre" },
    branch = "main",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          -- ignore error
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "VeryLazy", "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "main",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "VeryLazy", "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "andersevenrud/nvim_context_vt",
    event = { "VeryLazy", "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "aaronik/treewalker.nvim",
    opts = {},
    keys = {
      { "{", "<cmd>Treewalker Up<cr>", desc = "Tree Up", silent = true },
      { "}", "<cmd>Treewalker Down<cr>", desc = "Tree Down", silent = true },
      { "<C-[>", "<cmd>Treewalker SwapUp<cr>", desc = "Tree Swap Up", silent = true },
      { "<C-]>", "<cmd>Treewalker SwapDown<cr>", desc = "Tree Swap Down", silent = true },
    },
  },
}
