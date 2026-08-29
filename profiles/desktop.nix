{ inputs, ... }:

let
  home = inputs.self.modules.homeManager;
in
{
  flake.modules.homeManager."profile.desktop" = {
    imports = [
      home."profile.core"
      home."profile.gui-common"
      home."profile.lang-full"
      home."gui.brave"
      home."gui.niri"
      home."gui.qt"
      home."gui.zathura"
    ];
  };
}
