return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.sections.lualine_c[#opts.sections.lualine_c - 1] = { LazyVim.lualine.pretty_path({ length = 5 }) }
  end,
}
