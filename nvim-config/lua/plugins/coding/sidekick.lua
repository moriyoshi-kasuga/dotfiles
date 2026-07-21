return {
  "folke/sidekick.nvim",
  opts = {
    nes = { enabled = false },
    cli = {
      mux = {
        enabled = false,
      },
      win = {
        layout = "bottom",
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
    },
    {
      "<leader>ab",
      function()
        require("sidekick.cli").send({ name = "claude", msg = "{file}", focus = false })
      end,
      desc = "Add current buffer",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").send({ name = "claude", msg = "{selection}", focus = false })
      end,
      mode = "x",
      desc = "Send text to Claude",
    },
    {
      "<leader>al",
      function()
        require("sidekick.cli").send({ name = "claude", msg = "{line}", focus = false })
      end,
      mode = { "n", "x" },
      desc = "Send line to Claude",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<leader>as",
      function()
        local entry = require("oil").get_cursor_entry()
        local dir = require("oil").get_current_dir()
        if entry and dir then
          require("sidekick.cli").send({ name = "claude", msg = "@" .. dir .. entry.name, focus = false })
        end
      end,
      ft = "oil",
      mode = "n",
      desc = "Send oil entry to Claude",
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
