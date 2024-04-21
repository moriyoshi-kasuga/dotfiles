return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    require("which-key").register({
      ["g"] = { name = "+goto" },
      ["z"] = { name = "+fold" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
      ["<leader><Tab>"] = { name = "+tab" },
      ["<leader>q"] = { name = "+session" },
      ["<leader>s"] = { name = "+search" },
      ["<leader>c"] = { name = "+code" },
      ["<leader>f"] = { name = "+find" },
      ["<leader>g"] = { name = "+git" },
      ["<leader>n"] = { name = "+notify" },
      ["<leader>t"] = { name = "+translate" },
      ["<leader>w"] = { name = "+windows" },
      ["<leader>x"] = { name = "+diagnostics/quickfix" },
    })
  end,
}
