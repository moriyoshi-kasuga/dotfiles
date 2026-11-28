return {
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
    "moriyoshi-kasuga/kiln.nvim",
    lazy = false,
    version = "*",
    opts = {
      mappings = {
        common = {
          ["q"] = "close",
          ["gx"] = {
            function(ctx)
              -- a file line inside a commit also lists the commit, so files come first
              if #ctx.files > 0 then
                for _, f in ipairs(ctx.files) do
                  local cmd = { "gh", "browse", f.path }
                  if f.commit then
                    table.insert(cmd, "--commit=" .. f.commit)
                  end
                  vim.system(cmd, { cwd = ctx.root })
                end
                return
              end
              for _, c in ipairs(ctx.commits) do
                vim.system({ "gh", "browse", c.hash }, { cwd = ctx.root })
              end
            end,
            desc = "Browse files or commits on GitHub",
          },
        },
      },
    },
    keys = {
      { "g.", ":Kiln git ", desc = "Kiln git" },
      { "<C-.>", "<cmd>Kiln<cr>", desc = "Kiln Status" },
      { "<leader>gl", "<cmd>Kiln log<cr>", desc = "Kiln Log" },
      { "<leader>gL", "<cmd>Kiln log --all<cr>", desc = "Kiln Log (All)" },
      { "<leader>gf", "<cmd>Kiln log -- %<cr>", desc = "Kiln File History" },
      { "<leader>gb", "<cmd>Kiln branch<cr>", desc = "Kiln Branches" },
      { "<leader>gc", "<cmd>Kiln commit<cr>", desc = "Kiln Commit" },
      { "<leader>gd", "<cmd>Kiln diffsplit<cr>", desc = "Kiln Diff Split (index)" },
      { "<leader>gD", "<cmd>Kiln diff origin/HEAD<cr>", desc = "Kiln Diff (PR)" },
      { "<leader>go", "<cmd>Kiln output<cr>", desc = "Kiln Output" },
    },
  },
}
