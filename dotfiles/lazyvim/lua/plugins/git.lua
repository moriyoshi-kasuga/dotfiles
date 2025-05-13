return {
  { "lewis6991/gitsigns.nvim", enabled = false },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",

      "folke/snacks.nvim",
    },
    lazy = false,
    opts = {
      disable_hint = true,
      disable_signs = true,
      mappings = {
        status = {
          ["a"] = "Toggle",
        },
      },
    },
    keys = {
      { "gs", "<cmd>Neogit kind=tab<CR>", desc = "Neogit" },
      { "gS", "<cmd>Neogit kind=split<CR>", desc = "Neogit Split" },
    },
  },
  {
    "sindrets/diffview.nvim",
    lazy = false,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Diffview Open" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview File History" },
    },
  },
}
