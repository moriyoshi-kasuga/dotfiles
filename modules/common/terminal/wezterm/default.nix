{
  mkModule,
  username,
  pkgs,
  ...
}:

mkModule {
  name = "term.wezterm";
  homeModule =
    _:
    let
      weztermConfigRaw = builtins.readFile ./wezterm.lua;
      weztermConfig =
        builtins.replaceStrings
          [ "@COLORSCHEME@" "\"@BIGMONITOR@\"" ]
          [
            "Catppuccin Mocha"
            "true"
            # WIP: ここは後でもっと管理しやすく定義する、optionでsizeを要求するように改善する
            # (if bigMonitor then "true" else "false")
          ]
          weztermConfigRaw;
    in
    {
      xdg.configFile = {
        "wezterm/font.lua".source = ./config/font.lua;
        "wezterm/wezterm.lua".text = weztermConfig;
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
