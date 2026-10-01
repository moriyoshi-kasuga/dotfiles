_:

let
  nixpkgs.config.allowUnfree = true;
in
{
  flake.modules.nixos.base = { inherit nixpkgs; };
  flake.modules.darwin.base = { inherit nixpkgs; };
}
