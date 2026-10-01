_:

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
  flake.modules.nixos.user = mkUserModule (username: {
    users.users.${username} = {
      isNormalUser = true;
      description = username;
      group = username;
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "video"
        "docker"
      ];
    };

    users.groups.${username} = {
      name = username;
      members = [ username ];
      gid = 1000;
    };

    nix.settings.trusted-users = [ username ];
  });

  flake.modules.darwin.user = mkUserModule (username: {
    system.primaryUser = username;
    users.users.${username}.home = "/Users/${username}";

    nix.settings.trusted-users = [
      "root"
      username
    ];
  });
}
