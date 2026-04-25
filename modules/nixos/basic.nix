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

    xdg.mime.enable = true;

    services.libinput.enable = true;
    services.udisks2.enable = true;
    services.dbus.enable = true;
    services.upower.enable = true;
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

    services.power-profiles-daemon.enable = true;
    powerManagement.enable = true;

    services.logind.settings.Login = {
      HandlePowerKey = "ignore";
      LidSwitch = "suspend-then-hibernate";
      PowerKey = "hibernate";
      PowerKeyLongPress = "poweroff";
    };

    security = {
      polkit.enable = true;
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
