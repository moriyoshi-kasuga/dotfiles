return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      mux = {
        enabled = false,
      },
      win = {
        keys = {
          buffers = false,
          files = false,
        },
      },
    },
    picker = "fzf-lua",
  },
  keys = {
    { "<leader>a", nil, desc = "AI/Sidekick" },
    {
      "<tab>",
      function()
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Toggle Claude",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").focus({ name = "claude" })
      end,
      desc = "Focus Claude",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>ab",
      function()
        require("sidekick.cli").send({ name = "claude", msg = "{file}" })
      end,
      desc = "Add current buffer",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").send({ name = "claude", msg = "{selection}" })
      end,
      mode = "v",
      desc = "Send to Claude",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").send({ name = "claude", msg = "{file}" })
      end,
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick").nes_jump_or_apply()
      end,
      desc = "Accept diff",
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Deny diff",
    },
  },
}
