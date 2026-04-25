local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.disable_default_key_bindings = true
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

if wezterm.target_triple ~= "x86_64-unknown-linux-gnu" then
  config.window_decorations = "RESIZE"
end

config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.90
config.inactive_pane_hsb = {
  saturation = 1.0,
  brightness = 1.0,
}

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

local default_padding
if "@BIGMONITOR@" then
  default_padding = {
    left = 300,
    right = 100,
    top = 100,
    bottom = 0,
  }
else
  default_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  }
end

config.window_padding = default_padding

local zero_padding = { left = 0, right = 0, top = 0, bottom = 0 }
local padding_zeroed = false

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
    key = "f",
    mods = "CMD|SHIFT",
    action = wezterm.action_callback(function(window, _)
      if padding_zeroed then
        window:set_config_overrides({ window_padding = default_padding })
      else
        window:set_config_overrides({ window_padding = zero_padding })
      end
      padding_zeroed = not padding_zeroed
    end),
  },
}

return config
