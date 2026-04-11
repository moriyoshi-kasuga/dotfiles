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
      { "<leader><Tab>", group = "tab" },

      -- Test (Neotest)
      { "<leader>t", group = "test" },

      -- Search / Replace
      { "<leader>s", group = "search" },
      { "<leader>sn", group = "noice" },

      -- FZF / Find
      { ",", group = "find" },
      { ",g", group = "git" },
    },
  },
}
