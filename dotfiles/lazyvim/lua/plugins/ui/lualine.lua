local function maximize_status()
  return vim.t.maximized and "   " or ""
end

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.sections.lualine_c = vim.list_extend(opts.sections.lualine_c or {}, { maximize_status })
  end,
}
