vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = "#afff5f", bold = true, underline = true })
vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = "#5fffff", underline = true })

return {
  "jinh0/eyeliner.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePost" },
  opts = {
    highlight_on_key = true,
    dim = true,
    max_length = 200,
    default_keymaps = true,
  },
}
