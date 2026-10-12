_:

{
  flake.modules.nixos.pc =
    { pkgs, config, ... }:
    {
      users.users.${config.people.primaryUser}.packages = [ pkgs.discord ];
    };

  flake.modules.darwin.pc.homebrew.casks = [ "discord" ];
}
