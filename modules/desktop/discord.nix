_:

{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.discord ];
    };

  flake.modules.darwin.pc.homebrew.casks = [ "discord" ];
}
