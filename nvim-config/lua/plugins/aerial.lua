return {

  "stevearc/aerial.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "LspAttach" },
  opts = {
    layout = { min_width = 30 },
    attach_mode = "global",
    backends = { "lsp", "treesitter", "markdown", "man" },
    autojump = true,
    filter_kind = false,
    show_guides = true,
  },
  keys = {
    { "gsa", "<cmd>AerialToggle!<CR>", desc = "Aerial Outline" },
    { "[s", "<cmd>AerialPrev<CR>", desc = "Aerial: Previous symbol" },
    { "]s", "<cmd>AerialNext<CR>", desc = "Aerial: Next symbol" },
  },
}
