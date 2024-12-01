local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.disable_default_key_bindings = true
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
-- カラースキームの設定
config.color_scheme = "tokyonight_night"

-- 最初からフルスクリーンで起動
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():toggle_fullscreen()
end)

---- フォントの設定
local font = require("font")
font.register_fonts({
	{ name = "JetBrains Mono", mod = "font-jetbrains" },
	{ name = "Monaspace Neon", mod = "font-monaspace-neon" },
	{ name = "Monaspace Krypton", mod = "font-monaspace-krypton", default = true },
	{ name = "Ubuntu Mono", mod = "font-ubuntu" },
})
font.load_default(config)

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
	{
		key = "f",
		mods = "CMD",
		action = font.selector_action(),
	},
}

return config
