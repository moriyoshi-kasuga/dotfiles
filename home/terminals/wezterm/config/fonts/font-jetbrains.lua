local wezterm = require("wezterm")
return function(config, _)
  config.font = wezterm.font({
    family = "JetBrains Mono",
    weight = "Regular",
    stretch = "Normal",
    style = "Normal",
    harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
  })
  config.font_size = 15
end
