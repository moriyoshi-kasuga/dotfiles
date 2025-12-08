return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    branch = "main",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if vim.bo.filetype == "markdown" then
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
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
  },
  {
    "andersevenrud/nvim_context_vt",
  },
}
