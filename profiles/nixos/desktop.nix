{ inputs, ... }:

let
  nixos = inputs.self.modules.nixos;
in
{
  flake.modules.nixos."profile.desktop" = {
    imports = [
      nixos."profile.base"
      nixos.peripherals
      nixos.font
      nixos.library
      nixos."terminal.wezterm"
      nixos."gui.audio"
      nixos."gui.basic"
      nixos."gui.bluetooth"
      nixos."gui.brave"
      nixos."gui.game"
      nixos."gui.greetd"
      nixos."gui.i18n"
      nixos."gui.niri"
      nixos."gui.qt"
      nixos."gui.thunar"
    ];
  };
}
