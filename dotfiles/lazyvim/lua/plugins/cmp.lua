return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          border = "single",
          scrolloff = 1,
          scrollbar = false,
          columns = { { "kind_icon" }, { "label", "label_description", gap = 0 } },

          draw = {
            padding = 0,
            gap = 1,
            treesitter = true,
          },
        },

        documentation = {
          auto_show_delay_ms = 0,
          auto_show = true,

          window = {
            border = "single",
          },
        },
      },
    },
  },
}
