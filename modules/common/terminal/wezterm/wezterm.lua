local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local is_darwin = wezterm.target_triple:find("darwin") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil

-- --- General Settings ---
config.disable_default_key_bindings = true
config.check_for_updates = false
config.scrollback_lines = 10000
config.use_ime = true
if is_linux then
  config.enable_wayland = true
end

-- --- Appearance ---
config.color_scheme = "Catppuccin Macchiato"

config.font_size = 15
-- niri (tiling) manages window geometry; resizing on font change fights it
config.adjust_window_size_when_changing_font_size = is_darwin
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
if is_darwin then
  config.window_decorations = "RESIZE"
end

-- config.window_background_opacity = 0.92
-- if is_darwin then
--   config.macos_window_background_blur = 20
-- else
--   -- the blur is provided by niri
-- end

-- Tab bar
config.enable_tab_bar = false

-- Padding handling
local default_padding
--- This variable is provided by nix
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

-- Toggle a single config override per-window, preserving other overrides
local function toggle_override(key, on_value)
  return wezterm.action_callback(function(window, _)
    local overrides = window:get_config_overrides() or {}
    if overrides[key] ~= nil then
      overrides[key] = nil
    else
      overrides[key] = on_value
    end
    window:set_config_overrides(overrides)
  end)
end

-- --- Keybindings ---
config.keys = {
  -- Japanese backslash
  { key = "¥", action = act.SendString("\\") },

  -- Font size
  { key = "=", mods = "CMD", action = act.IncreaseFontSize },
  { key = "-", mods = "CMD", action = act.DecreaseFontSize },
  { key = ".", mods = "CMD", action = act.ResetFontSize },

  -- Window
  { key = "n", mods = "CMD", action = act.SpawnWindow },

  -- Clipboard
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },

  -- Scrollback
  { key = "f", mods = "CTRL|SHIFT", action = act.Search("CurrentSelectionOrEmptyString") },
  { key = "x", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
  { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
  { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },

  -- Toggles
  -- {
  --   key = "T",
  --   mods = "CMD|SHIFT",
  --   action = toggle_override("window_background_opacity", 1.0),
  -- },
  {
    key = "o",
    mods = "CMD|SHIFT",
    action = toggle_override("window_padding", { left = 0, right = 0, top = 0, bottom = 0 }),
  },
}

if is_darwin then
  table.insert(config.keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
  table.insert(config.keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })
  table.insert(config.keys, { key = "f", mods = "CMD", action = act.Search("CurrentSelectionOrEmptyString") })
end

return config
