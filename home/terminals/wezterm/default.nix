{ bigMonitor, ... }:

let
  weztermConfigRaw = builtins.readFile ./wezterm.lua;
  weztermConfig =
    builtins.replaceStrings
      [ "@COLORSCHEME@" "\"@BIGMONITOR@\"" ]
      [
        "Catppuccin Mocha"
        (if bigMonitor then "true" else "false")
      ]
      weztermConfigRaw;
in
{
  xdg.configFile = {
    "wezterm/font.lua".source = ./config/font.lua;
    "wezterm/wezterm.lua".text = weztermConfig;
  };
}
