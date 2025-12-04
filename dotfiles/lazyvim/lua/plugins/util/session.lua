return {
  "olimorris/persisted.nvim",
  lazy = true,
  event = "VimEnter",
  opts = {
    autoload = false,
    autosave = true,
    use_git_branch = true,
  },
}
