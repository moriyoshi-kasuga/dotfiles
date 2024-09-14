local wezterm = require("wezterm")
return function(config, _)
	config.font =
		wezterm.font("MonaspiceKr Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
	config.font_size = 16.3
end
