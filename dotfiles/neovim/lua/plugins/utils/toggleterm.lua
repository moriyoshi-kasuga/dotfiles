return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<C-\\>", desc = "Toggle Terminal" },
    { "<leader>tf", desc = "Float Terminal" },
    { "<leader>th", desc = "Horizontal Terminal" },
    { "<leader>tv", desc = "Vertical Terminal" },
  },
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_terminals = false,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "single",
      winblend = 0,
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local Terminal = require("toggleterm.terminal").Terminal

    -- Float terminal
    local float_term = Terminal:new({ direction = "float" })
    vim.keymap.set("n", "<leader>tf", function()
      float_term:toggle()
    end, { desc = "Float Terminal" })

    -- Horizontal terminal
    local horizontal_term = Terminal:new({ direction = "horizontal" })
    vim.keymap.set("n", "<leader>th", function()
      horizontal_term:toggle()
    end, { desc = "Horizontal Terminal" })

    -- Vertical terminal
    local vertical_term = Terminal:new({ direction = "vertical" })
    vim.keymap.set("n", "<leader>tv", function()
      vertical_term:toggle()
    end, { desc = "Vertical Terminal" })
  end,
}
