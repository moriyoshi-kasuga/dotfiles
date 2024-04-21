return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    map_bs = false,
    map_c_h = true,
    map_c_w = true,
    fast_wrap = {
      map = "<C-g>g",
    },
  },
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)
  end,
}
