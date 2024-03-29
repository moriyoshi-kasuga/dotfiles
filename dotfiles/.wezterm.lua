local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.hide_tab_bar_if_only_one_tab = true
-- カラースキームの設定
config.color_scheme = "tokyonight_night"

-- 最初からフルスクリーンで起動
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():toggle_fullscreen()
end)

-- フォントの設定
-- config.font = wezterm.font("Cica", { weight = "Regular", stretch = "Normal", style = "Normal" })
-- config.font_size = 17
config.font = wezterm.font("UbuntuMono Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 17
-- config.font = wezterm.font("UDEV Gothic 35NF", { weight = "Regular", stretch = "Normal", style = "Normal" })
-- config.font_size = 14

-- フォントサイズの設定

config.window_padding = {
	left = 2,
	right = 2,
	top = 30,
	bottom = 0,
}

-- ショートカットキー設定
config.keys = {
	-- Alt(Opt)+Shift+Fでフルスクリーン切り替え
	{
		key = "f",
		mods = "SHIFT|META",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "¥",
		action = wezterm.action({ SendString = "\\" }),
	},
}

return config
