return {
  { "folke/persistence.nvim", enabled = false },
  {
    "olimorris/persisted.nvim",
    opts = {
      autoload = false,
      autosave = true,
      use_git_branch = true,
    },
  },
}
