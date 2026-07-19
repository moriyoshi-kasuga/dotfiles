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
    services.dbus.enable = true;
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    environment.systemPackages = with pkgs; [
      vim-full
      wget
      pciutils
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

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };
  };
}
