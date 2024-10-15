return {
  "petertriho/nvim-scrollbar",
  event = { "VeryLazy", "LazyFile" },
  config = function()
    local colors = require("tokyonight.colors").setup()

    require("scrollbar").setup({
      excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "noice",
        "neo-tree",
        "neo-tree-popup",
      },
      handle = {
        color = colors.bg_highlight,
      },
      marks = {
        Search = { color = colors.orange },
        Error = { color = colors.error },
        Warn = { color = colors.warning },
        Info = { color = colors.info },
        Hint = { color = colors.hint },
        Misc = { color = colors.purple },
      },
    })
  end,
}
