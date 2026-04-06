local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.disable_default_key_bindings = true
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.color_scheme = "Catppuccin Mocha"

-- Linuxはniriを使うのでフルスクリーンで起動しないようにする
if wezterm.target_triple ~= "x86_64-unknown-linux-gnu" then
  -- 最初からフルスクリーンで起動
  local mux = wezterm.mux
  wezterm.on("gui-startup", function()
    local _, pane, window = mux.spawn_window({})
    window:gui_window():perform_action(wezterm.action.ToggleFullScreen, pane)
  end)
  config.native_macos_fullscreen_mode = true
end

config.font = wezterm.font_with_fallback({
  {
    family = "JetBrainsMono Nerd Font",
    weight = "Regular",
    stretch = "Normal",
    style = "Normal",
    harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
  },
  {
    family = "Noto Sans Mono CJK JP",
    weight = "Regular",
    stretch = "Normal",
    style = "Normal",
  },
  "Noto Color Emoji",
})
config.font_size = 15
config.adjust_window_size_when_changing_font_size = true
config.cell_width = 1.0
config.line_height = 1.0
config.use_cap_height_to_scale_fallback_fonts = true

if "@BIGMONITOR@" then
  config.window_padding = {
    left = 180,
    right = 180,
    top = 100,
    bottom = 80,
  }
else
  config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  }
end

-- ショートカットキー設定
config.keys = {
  {
    key = "Enter",
    mods = "CMD",
    action = wezterm.action.ToggleFullScreen,
  },
  {
    key = "Enter",
    mods = "SUPER",
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
    key = "c",
    mods = "SUPER",
    action = wezterm.action.CopyTo("Clipboard"),
  },
  {
    key = "v",
    mods = "SUPER",
    action = wezterm.action.PasteFrom("Clipboard"),
  },
  {
    key = "c",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CopyTo("Clipboard"),
  },
  {
    key = "v",
    mods = "CTRL",
    action = wezterm.action.PasteFrom("Clipboard"),
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
    key = "=",
    mods = "SUPER",
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = "-",
    mods = "SUPER",
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = ".",
    mods = "SUPER",
    action = wezterm.action.ResetFontSize,
  },
  {
    key = "l",
    mods = "CMD",
    action = wezterm.action.ShowDebugOverlay,
  },
}

return config
