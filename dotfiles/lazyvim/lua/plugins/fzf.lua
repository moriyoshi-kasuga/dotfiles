return {
  "ibhagwan/fzf-lua",
  opts = {
    files = {
      formatter = "path.filename_first",
    },
    keymap = {
      fzf = {
        ["ctrl-l"] = "abort",
      },
    },
  },
}
