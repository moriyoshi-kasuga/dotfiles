return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    opts = {
      keymaps = {
        view = {
          prev_file = "<S-k>",
          next_file = "<S-j>",
        },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>CodeDiff file HEAD<CR>", desc = "CodeDiff Open (Buffer)" },
      { "<leader>gD", "<cmd>CodeDiff<CR>", desc = "CodeDiff Open (All)" },
      { "<leader>gf", "<cmd>CodeDiff history %<CR>", desc = "CodeDiff File History (Current)" },
      { "<leader>gF", "<cmd>CodeDiff history<CR>", desc = "CodeDiff File History (All)" },
    },
  },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = {
      picker = "fzf-lua",
      enable_builtin = true,
    },
    keys = {
      {
        "<leader>oi",
        "<CMD>Octo issue list<CR>",
        desc = "List GitHub Issues",
      },
      {
        "<leader>op",
        "<CMD>Octo pr list<CR>",
        desc = "List GitHub PullRequests",
      },
      {
        "<leader>od",
        "<CMD>Octo discussion list<CR>",
        desc = "List GitHub Discussions",
      },
      {
        "<leader>on",
        "<CMD>Octo notification list<CR>",
        desc = "List GitHub Notifications",
      },
      {
        "<leader>os",
        function()
          require("octo.utils").create_base_search_command({ include_current_repo = true })
        end,
        desc = "Search GitHub",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
    },
  },
  {
    "tpope/vim-fugitive",
    keys = {
      {
        "<C-.>",
        "<cmd>tab G<cr>",
        desc = "Show Fugitive",
      },
    },
  },
}
