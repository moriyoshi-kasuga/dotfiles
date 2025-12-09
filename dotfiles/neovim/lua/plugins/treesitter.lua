return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "VeryLazy", "BufReadPost", "BufNewFile", "BufWritePre" },
    branch = "main",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if args.file == "markdown" or args.file == "markdown_inline" then
            return
          end
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
    opts = {
      ---@param buf integer
      ---@return boolean
      on_attach = function(buf)
        local filetype = vim.bo[buf].filetype
        if filetype == "markdown" or filetype == "markdown_inline" then
          return false
        end
        return true
      end,
    },
  },
  {
    "andersevenrud/nvim_context_vt",
    event = { "VeryLazy", "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      disable_ft = {
        "markdown",
        "markdown_inline",
        "yaml",
        "toml",
      },
    },
  },
  {
    "aaronik/treewalker.nvim",
    opts = {},
    keys = {
      { "{", "<cmd>Treewalker Up<cr>", desc = "Tree Up", silent = true },
      { "}", "<cmd>Treewalker Down<cr>", desc = "Tree Down", silent = true },
      { "[[", "<cmd>Treewalker SwapUp<cr>", desc = "Tree Swap Up", silent = true },
      { "]]", "<cmd>Treewalker SwapDown<cr>", desc = "Tree Swap Down", silent = true },
    },
  },
}
