local wezterm = require("wezterm")
return function(config, _)
	config.font = wezterm.font("JetBrains Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
	config.font_size = 15
end
