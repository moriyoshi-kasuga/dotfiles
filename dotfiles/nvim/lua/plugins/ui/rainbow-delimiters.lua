return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = function()
    require("rainbow-delimiters.setup").setup({
      highlight = {
        "RainbowDelimiterBlue",
        "RainbowDelimiterCyan",
        "RainbowDelimiterGreen",
      },
    })
  end,
}
