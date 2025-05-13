return {
  { "folke/persistence.nvim", enabled = false },
  {
    "olimorris/persisted.nvim",
    lazy = false,
    opts = {
      autoload = false,
      autosave = true,
      use_git_branch = true,
    },
  },
}
