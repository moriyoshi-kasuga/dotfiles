local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

local is_darwin = wezterm.target_triple:find("darwin") ~= nil

-- --- General Settings ---
config.disable_default_key_bindings = true
config.check_for_updates = false
config.scrollback_lines = 10000
-- Match the 165Hz desktop monitor; the default caps rendering at 60fps
config.max_fps = 165

-- --- Appearance ---
---@diagnostic disable-next-line: undefined-global
config.color_scheme = COLOR_SCHEME

config.font_size = 15
-- niri (tiling) manages window geometry; resizing on font change fights it
config.adjust_window_size_when_changing_font_size = is_darwin
config.use_cap_height_to_scale_fallback_fonts = true

-- Sharper, more consistent glyph rendering across displays
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"

local ligature_features = { "calt=0", "clig=0", "liga=0" }

-- The font itself comes from style.fonts.monospace (modules/style/fonts.nix).
-- Fonts without Japanese glyphs fall back to Noto CJK.
---@diagnostic disable-next-line: undefined-global
local monospace = { family = MONOSPACE_FAMILY, fallback = not MONOSPACE_HAS_CJK }

-- Build a fallback stack for a given weight/style, so Bold and Italic use
-- the font's real glyphs instead of wezterm-synthesized ones.
local function monospace_font(weight, style)
  local fallback = {
    {
      family = monospace.family,
      weight = weight,
      stretch = "Normal",
      style = style,
      harfbuzz_features = ligature_features,
    },
    -- Emoji before CJK: symbols present in both should render in color.
    "Noto Color Emoji",
  }
  if monospace.fallback then
    table.insert(fallback, {
      family = "Noto Sans Mono CJK JP",
      weight = "Regular",
      stretch = "Normal",
      style = "Normal",
    })
  end
  return wezterm.font_with_fallback(fallback)
end

config.font = monospace_font("Regular", "Normal")
config.font_rules = {
  { intensity = "Bold", italic = false, font = monospace_font("Bold", "Normal") },
  { intensity = "Normal", italic = true, font = monospace_font("Regular", "Italic") },
  { intensity = "Bold", italic = true, font = monospace_font("Bold", "Italic") },
}

-- Window settings
if is_darwin then
  config.window_decorations = "RESIZE"
end

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
  { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },

  -- Scrollback search and copy mode are tmux's job. QuickSelect only reads
  -- the visible screen, so it still works inside tmux.
  { key = "Space", mods = "CTRL|SHIFT", action = act.QuickSelect },

  -- Reaches actions that have no binding of their own
  { key = "p", mods = "CTRL|SHIFT", action = act.ActivateCommandPalette },

  -- Toggles
  {
    key = "o",
    mods = "CMD|SHIFT",
    action = toggle_override("window_padding", { left = 0, right = 0, top = 0, bottom = 0 }),
  },
}

if is_darwin then
  table.insert(config.keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
  table.insert(config.keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })
end

return config
