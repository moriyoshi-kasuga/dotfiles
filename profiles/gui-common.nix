{ inputs, ... }:

let
  home = inputs.self.modules.homeManager;
in
{
  flake.modules.homeManager."profile.gui-common" = {
    imports = [
      home."terminal.wezterm"
      home.wallpaper
    ];
  };
}
