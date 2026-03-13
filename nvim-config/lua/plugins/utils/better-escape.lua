return {
  "max397574/better-escape.nvim",
  event = "InsertEnter",
  opts = {
    default_mappings = false,
    mappings = {
      -- i for insert
      i = {
        j = {
          k = function()
            vim.api.nvim_input("<esc>")
            require("blink-cmp").hide()
          end,
        },
      },
    },
  },
}
