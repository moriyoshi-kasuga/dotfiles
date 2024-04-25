return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  version = "*",
  config = function(_, opts)
    require("toggleterm").setup(opts)
    local Terminal = require("toggleterm.terminal").Terminal
    local term = Terminal:new({
      direction = "float",
      float_opts = {
        border = "double",
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<c-_>", "<cmd>close<CR>", { silent = true })
      end,
    })
    vim.keymap.set("n", "<c-_>", function()
      term:toggle()
    end, { desc = "Toggle Term", noremap = true, silent = true })
    vim.keymap.set("n", "<leader><c-_>", function()
      Terminal:new({
        dir = vim.fn.expand("%:p:h"),
        direction = "float",
        float_opts = {
          border = "double",
        },
        on_open = function(open)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(open.bufnr, "t", "<c-_>", "<cmd>close<CR>", { silent = true })
        end,
      }):toggle()
    end, { desc = "Toggle Term", noremap = true, silent = true })
  end,
}
