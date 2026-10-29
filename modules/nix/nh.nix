_:

let
  # nixos/darwin 共通。古い世代の掃除は nix.gc ではなく nh clean に任せる。
  # --keep を付けて、しばらく rebuild しなかったマシンでもロールバック先を残す。
  common =
    { config, lib, ... }:
    {
      options.people.flakeHost = lib.mkOption {
        type = lib.types.str;
        description = ''
          Name of this host under nixosConfigurations / darwinConfigurations.
          nh looks up the configuration by hostname, which differs from the configuration name on most hosts.
        '';
      };

      config.programs.nh = {
        enable = true;
        flake = "${
          config.users.users.${config.people.primaryUser}.home
        }/dotfiles#${config.people.flakeHost}";
        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 5";
        };
      };
    };
in
{
  flake.modules.nixos.base = {
    imports = [ common ];

    programs.nh.clean.dates = "weekly";
  };

  flake.modules.darwin.base = {
    imports = [ common ];

    programs.nh.clean.interval = {
      Weekday = 1;
      Hour = 0;
      Minute = 0;
    };
  };
}
