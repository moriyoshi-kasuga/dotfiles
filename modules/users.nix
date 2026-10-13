{ lib, ... }:

let
  # nixos/darwin 共通: primaryUser と、その home-manager 設定を受け取るオプション。
  # home.username / home.homeDirectory は home-manager が users.users.<u> から自動で設定する。
  mkUserModule =
    extra:
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      username = config.people.primaryUser;
    in
    {
      options.people = {
        primaryUser = lib.mkOption {
          type = lib.types.str;
          description = "Primary user of this host.";
        };
        home = lib.mkOption {
          type = lib.types.deferredModule;
          default = { };
          description = "home-manager configuration for the primary user.";
        };
      };

      config = lib.mkMerge [
        {
          users.users.${username}.shell = pkgs.fish;
          home-manager.users.${username}.imports = [ config.people.home ];
        }
        (extra username)
      ];
    };
in
{
  flake.modules.nixos.base = mkUserModule (username: {
    users.users.${username} = {
      isNormalUser = true;
      description = username;
      group = username;
      extraGroups = [
        "wheel"
        "input"
        "video"
      ];
    };

    users.groups.${username} = {
      name = username;
      members = [ username ];
      gid = 1000;
    };

    nix.settings.trusted-users = [ username ];
  });

  flake.modules.darwin.base = mkUserModule (username: {
    system.primaryUser = username;

    # nix-darwin は knownUsers にいる user にだけ shell を反映する。
    # uid が実際と違うと warning を出してその user を飛ばすだけなので、違う Mac は host で上書きする。
    users.knownUsers = [ username ];
    users.users.${username} = {
      home = "/Users/${username}";
      uid = lib.mkDefault 501;
    };

    nix.settings.trusted-users = [ username ];
  });
}
