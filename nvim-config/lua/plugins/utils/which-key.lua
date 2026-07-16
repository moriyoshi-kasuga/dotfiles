return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    spec = {
      -- Buffer
      { "<leader>b", group = "buffer" },

      -- Window
      { "<leader>w", group = "window" },

      -- Git
      { "<leader>g", group = "git" },

      -- Code / LSP
      { "<leader>c", group = "code" },

      -- UI Toggles
      { "<leader>u", group = "ui" },

      -- Tab
      { "<C-g>", group = "tab" },

      -- Test (Neotest)
      { "<leader>t", group = "test" },

      -- Debug (nvim-dap)
      { "<leader>d", group = "dap" },

      -- Scala / Java (metals, jdtls)
      { "<leader>m", group = "scala/java" },

      -- GitHub (octo.nvim)
      { "<leader>o", group = "octo" },

      -- Peek (overlook.nvim)
      { "<leader>p", group = "peek" },

      -- Trouble
      { "<leader>x", group = "trouble" },

      -- Search / Replace
      { "<leader>s", group = "search" },

      -- FZF / Find
      { ",", group = "find" },
      { ",g", group = "git" },
    },
  },
}
