return {
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^3",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "haskell" } },
  },

  -- {
  --   "mason-org/mason.nvim",
  --   opts = { ensure_installed = { "haskell-language-server" } },
  -- },
  --
  -- {
  --   "mfussenegger/nvim-dap",
  --   optional = true,
  --   dependencies = {
  --     {
  --       "mason-org/mason.nvim",
  --       opts = { ensure_installed = { "haskell-debug-adapter" } },
  --     },
  --   },
  -- },
  --
  -- {
  --   "nvim-neotest/neotest",
  --   optional = true,
  --   dependencies = {
  --     { "mrcjkb/neotest-haskell" },
  --   },
  --   opts = {
  --     adapters = {
  --       ["neotest-haskell"] = {},
  --     },
  --   },
  -- },

  -- Make sure lspconfig doesn't start hls,
  -- as it conflicts with haskell-tools
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        hls = function()
          return true
        end,
      },
    },
  },
}
