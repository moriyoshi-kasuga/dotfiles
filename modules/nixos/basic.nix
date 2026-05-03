{
  mkModule,
  username,
  pkgs,
  ...
}:

mkModule {
  name = "nixos.basic";
  inheritModule = "nixos";
  nixosModule = {
    nixpkgs.config.allowUnfree = true;

    services.dbus.enable = true;
    services.openssh.enable = true;

    environment.systemPackages = with pkgs; [
      vim-full
      wget
    ];

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;
    };

    security = {
      sudo.execWheelOnly = true;
    };

    users.users.${username} = {
      isNormalUser = true;
      description = username;
      group = username;
      extraGroups = [
        "networkmanager"
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

    programs.nix-ld = {
      enable = true;
    };

    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 8 * 1024; # MB
      }
    ];
  };
}
