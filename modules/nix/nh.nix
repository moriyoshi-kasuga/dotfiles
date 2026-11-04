{ config, lib, ... }:

let
  # nixos/darwin 共通。古い世代の掃除は nix.gc ではなく nh clean に任せる。
  # --keep を付けて、しばらく rebuild しなかったマシンでもロールバック先を残す。
  common =
    { config, ... }:
    {
      programs.nh = {
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
  # nh は people.flakeHost の名前で設定を選ぶので、設定の名前とずれた host は別の host を build する
  perSystem =
    { pkgs, ... }:
    let
      mismatched = lib.attrNames (
        lib.filterAttrs (name: cfg: cfg.config.people.flakeHost != name) (
          config.flake.nixosConfigurations // config.flake.darwinConfigurations
        )
      );
    in
    {
      checks.flake-host = pkgs.runCommand "flake-host" { } ''
        ${lib.optionalString (mismatched != [ ]) ''
          echo "people.flakeHost が設定の名前と違う host: ${toString mismatched}" >&2
          exit 1
        ''}
        touch "$out"
      '';
    };

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
