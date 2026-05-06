local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- --- General Settings ---
config.disable_default_key_bindings = true
config.hide_tab_bar_if_only_one_tab = true
config.check_for_updates = false
config.scrollback_lines = 10000
if wezterm.target_triple:find("linux") then
  config.enable_wayland = true
end

-- --- Appearance ---
config.color_scheme = "Catppuccin Mocha"

config.font_size = 15
config.adjust_window_size_when_changing_font_size = true
config.cell_width = 1.0
config.line_height = 1.0
config.use_cap_height_to_scale_fallback_fonts = true

config.font = wezterm.font_with_fallback({
  {
    family = "Maple Mono Normal NL NF",
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

-- Window settings
if wezterm.target_triple:find("darwin") then
  config.window_decorations = "RESIZE"
end

local window_background_opacity
if wezterm.target_triple:find("darwin") then
  window_background_opacity = 0.8
  config.macos_window_background_blur = 20
else
  window_background_opacity = 0.92
  -- the blur is provide by niri
end
config.window_background_opacity = window_background_opacity
local enabled_transparent = true

-- Tab bar
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

-- Padding handling
local default_padding
---@diagnostic disable-next-line: undefined-global
if BIG_MONITOR then
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

-- --- Keybindings ---
config.keys = {
  -- Japanese backslash
  { key = "¥", action = act.SendString("\\") },

  -- Font size
  { key = "=", mods = "CMD", action = act.IncreaseFontSize },
  { key = "-", mods = "CMD", action = act.DecreaseFontSize },
  { key = ".", mods = "CMD", action = act.ResetFontSize },

  -- Paste
  { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },

  -- Toggles
  {
    key = "T",
    mods = "CMD|SHIFT",
    action = wezterm.action_callback(function(window, _)
      if enabled_transparent then
        window:set_config_overrides({ window_background_opacity = 1.0 })
      else
        window:set_config_overrides({ window_background_opacity = window_background_opacity })
      end
      enabled_transparent = not enabled_transparent
    end),
  },
  {
    key = "o",
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

if wezterm.target_triple:find("darwin") then
  table.insert(config.keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })
end

return config
