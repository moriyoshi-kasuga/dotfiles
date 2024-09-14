local wezterm = require("wezterm")
return function(config, _)
	config.font =
		wezterm.font("UbuntuMono Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
	config.font_size = 19.5
end
