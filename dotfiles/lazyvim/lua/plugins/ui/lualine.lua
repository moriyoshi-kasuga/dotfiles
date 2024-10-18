local function maximize_status()
  return vim.t.maximized and "   " or ""
end

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local x = opts.sections.lualine_x[#opts.sections.lualine_x]
    opts.sections.lualine_x = { maximize_status, x }
    opts.sections.lualine_c[#opts.sections.lualine_c] = { LazyVim.lualine.pretty_path({ length = 5 }) }
    opts.sections.lualine_z = {}
  end,
}
