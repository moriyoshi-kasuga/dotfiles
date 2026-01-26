local wezterm = require("wezterm")
return function(config, _)
  config.font = wezterm.font("CommitMono Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
  config.font_size = 18
end
