{ lib }:

{
  mkModule = import ./mkModule.nix { inherit lib; };
  mkModuleDarwin = import ./mkModuleDarwin.nix { inherit lib; };
  mkModuleNixOS = import ./mkModuleNixOS.nix { inherit lib; };
}
