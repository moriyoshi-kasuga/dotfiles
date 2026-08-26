{ inputs, ... }:

let
  nixos = inputs.self.modules.nixos;
in
{
  flake.modules.nixos."host.desktop" = {
    imports = [
      nixos.base
      nixos.basic
      nixos.i18n
      nixos.network
      nixos.tailscale
      nixos.font
      nixos.library
      nixos."shell.fish"
      nixos."shell.zsh"
      nixos."terminal.wezterm"
      nixos."tool.docker"
      nixos."gui.audio"
      nixos."gui.basic"
      nixos."gui.bluetooth"
      nixos."gui.brave"
      nixos."gui.game"
      nixos."gui.i18n"
      nixos."gui.niri"
      nixos."gui.qt"
      nixos."gui.sddm"
      nixos."gui.thunar"
      nixos."gui.zed"
    ];
  };
}
