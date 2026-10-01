_:

let
  version = "26.05";
in
{
  flake.modules.homeManager.base.home.stateVersion = version;
  flake.modules.nixos.base.system.stateVersion = version;
  flake.modules.darwin.base.system.stateVersion = 6;
}
