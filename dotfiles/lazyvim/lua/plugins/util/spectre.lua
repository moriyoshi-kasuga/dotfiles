return {
  "nvim-pack/nvim-spectre",
  opts = {
    default = {
      replace = {
        cmd = "oxi",
      },
    },
    find_engine = {
      ["rg"] = {
        cmd = "rg",
        args = {
          "--pcre2",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
      },
    },
  },
}
