return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  opts = {
    flavour = "macchiato",
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin-macchiato")
  end,
}
