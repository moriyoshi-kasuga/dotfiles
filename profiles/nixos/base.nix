{ inputs, ... }:

let
  nixos = inputs.self.modules.nixos;
in
{
  flake.modules.nixos."profile.base" = {
    imports = [
      nixos.base
      nixos.user
      nixos.system
      nixos.i18n
      nixos.network
      nixos.tailscale
      nixos."shell.fish"
      nixos."shell.zsh"
      nixos."tool.docker"
    ];
  };
}
