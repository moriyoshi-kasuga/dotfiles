local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.disable_default_key_bindings = true
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
-- カラースキームの設定
config.color_scheme = "tokyonight_moon"

-- 最初からフルスクリーンで起動
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():toggle_fullscreen()
end)

---- フォントの設定

--- Monaspace
-- config.font = wezterm.font("MonaspiceKr Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
-- config.font = wezterm.font("MonaspiceXe Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
-- config.font = wezterm.font("MonaspiceNe Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
-- config.font_size = 16.3

--- UbuntuMono
-- config.font = wezterm.font("UbuntuMono Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
-- config.font_size = 17.5

--- JetBrains
config.font = wezterm.font("JetBrains Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 15

config.window_padding = {
	left = 0,
	right = 0,
	top = 30,
	bottom = 0,
}

-- ショートカットキー設定
config.keys = {
	-- CMD(command)+Enterでフルスクリーン切り替え
	{
		key = "Enter",
		mods = "CMD",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "¥",
		action = wezterm.action({ SendString = "\\" }),
	},
	{
		key = "c",
		mods = "CMD",
		action = wezterm.action.CopyTo("Clipboard"),
	},
	{
		key = "v",
		mods = "CMD",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

return config
