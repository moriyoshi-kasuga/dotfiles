return {
  {
    "saghen/blink.cmp",
    opts = {
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },

      completion = {
        accept = {
          auto_brackets = { enabled = false },
        },

        menu = {
          border = "single",
          scrolloff = 1,
          scrollbar = false,
        },

        documentation = {
          auto_show = true,

          window = {
            border = "single",
          },
        },
      },

      signature = { window = { border = "single" } },
    },
  },
}
