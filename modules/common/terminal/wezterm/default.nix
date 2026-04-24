{
  mkModule,
  username,
  lib,
  pkgs,
  ...
}:

with lib;

mkModule {
  name = "term.wezterm";
  options = {
    bigMonitor = mkEnableOption "Create a padding for big monitor";
  };
  homeModule =
    { cfg, ... }:
    let
      weztermConfigRaw = builtins.readFile ./wezterm.lua;
      weztermConfig =
        builtins.replaceStrings
          [ "\"@BIGMONITOR@\"" ]
          [
            (if cfg.bigMonitor then "true" else "false")
          ]
          weztermConfigRaw;
    in
    {
      home.file = {
        ".config/wezterm/wezterm.lua".text = weztermConfig;
      };
    };
  nixosModule = {
    users.users.${username}.packages = [
      pkgs.wezterm
    ];
  };
  darwinModule = {
    homebrew.casks = [
      "wezterm"
    ];
  };
}
