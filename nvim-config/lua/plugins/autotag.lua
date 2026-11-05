return {
  "windwp/nvim-ts-autotag",
  event = "InsertEnter",
  opts = {
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true,
    },
    -- conflict with windwp/nvim-autopairs
    per_filetype = {
      ["rust"] = {
        enable_close = false,
        enable_rename = false,
        enable_close_on_slash = false,
      },
    },
  },
}
