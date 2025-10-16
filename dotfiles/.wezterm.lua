local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.disable_default_key_bindings = true
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.color_scheme = "@COLORSCHEME@" --binding by nix

-- 最初からフルスクリーンで起動
local mux = wezterm.mux
wezterm.on("gui-startup", function()
	local _, pane, window = mux.spawn_window({})
	window:gui_window():perform_action(wezterm.action.ToggleFullScreen, pane)
end)
config.native_macos_fullscreen_mode = true

---- フォントの設定
local font = require("font")
font.register_fonts({
	{ name = "JetBrains Mono", mod = "font-jetbrains", default = true },
	{ name = "Monaspace Neon", mod = "font-monaspace-neon" },
	{ name = "Monaspace Krypton", mod = "font-monaspace-krypton" },
	{ name = "CommitMono", mod = "font-commit" },
})
font.load_default(config)
config.adjust_window_size_when_changing_font_size = false

config.window_padding = {
	left = 200,
	right = 200,
	top = 200,
	bottom = 0,
}

-- ショートカットキー設定
config.keys = {
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
	{
		key = "+",
		mods = "CMD",
		action = wezterm.action.IncreaseFontSize,
	},
	{
		key = "-",
		mods = "CMD",
		action = wezterm.action.DecreaseFontSize,
	},
	{
		key = ".",
		mods = "CMD",
		action = wezterm.action.ResetFontSize,
	},
	{
		key = "l",
		mods = "CMD",
		action = wezterm.action.ShowDebugOverlay,
	},
}

return config
