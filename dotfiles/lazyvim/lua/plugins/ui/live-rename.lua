return {
  {
    "saecki/live-rename.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "<leader>cr",
        function()
          require("live-rename").rename()
        end,
        desc = "LSP rename",
      }
    end,
  },
}
