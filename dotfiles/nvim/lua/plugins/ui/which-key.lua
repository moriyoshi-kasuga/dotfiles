return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    require("which-key").register({
      ["<leader><tab>"] = {name="+tab"},
      ["<leader>b"] = {name="+buffer"},
      ["<leader>s"] = {name="+search"},
      ["<leader>f"] = {name="+find"},
      ["<leader>g"] = {name="+git"},
      ["<leader>t"] = {name="+translate"},
    })
  end,
}
