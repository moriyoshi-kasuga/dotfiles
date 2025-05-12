return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    filetypes = { "*" },
    user_default_options = {
      RGB = true, -- #RGB hex codes, #fff, #ffff, #ffffff
      names = true, -- Blue, green
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      mode = "background",
      tailwind = true,
      sass = { enable = true, parsers = { "css" } },
      virtualtext = "■",
      always_update = false,
    },
  },
}
