return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    opts = {},
    keys = {
      { "<leader>gd", "<cmd>CodeDiff file HEAD<CR>", desc = "CodeDiff Open (Buffer)" },
      { "<leader>gD", "<cmd>CodeDiff<CR>", desc = "CodeDiff Open (All)" },
      { "<leader>gf", "<cmd>CodeDiff history %<CR>", desc = "CodeDiff File History (Current)" },
      { "<leader>gF", "<cmd>CodeDiff history<CR>", desc = "CodeDiff File History (All)" },
    },
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "esmuellert/codediff.nvim",

      "ibhagwan/fzf-lua",
    },
    cmd = "Neogit",
    keys = {
      { "<C-.>", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signcolumn = true,
      numhl = false,
      linehl = false,
      current_line_blame = false,
      on_attach = function(buffer)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", function()
          gitsigns.nav_hunk("next")
        end, "Next Hunk")
        map("n", "[h", function()
          gitsigns.nav_hunk("prev")
        end, "Previous Hunk")

        map("n", "<leader>hs", gitsigns.stage_hunk, "Stage Hunk")
        map("n", "<leader>hr", gitsigns.reset_hunk, "Reset Hunk")
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage Hunk")
        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Hunk")
        map("n", "<leader>hS", gitsigns.stage_buffer, "Stage Buffer")
        map("n", "<leader>hR", gitsigns.reset_buffer, "Reset Buffer")
        map("n", "<leader>hu", gitsigns.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hp", gitsigns.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>htb", gitsigns.toggle_current_line_blame, "Toggle Line Blame")
        map("n", "<leader>htd", gitsigns.toggle_deleted, "Toggle Deleted")
        map("n", "<leader>hd", gitsigns.diffthis, "Diff This")
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "GitSigns Select Hunk")
      end,
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
}
