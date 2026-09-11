_:

{
  flake.modules.nixos.basic =
    { pkgs, config, ... }:
    let
      username = config.people.primaryUser;
    in
    {
      services.dbus.enable = true;
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      documentation.man.cache.enable = false;

      environment.systemPackages = with pkgs; [
        vim-full
        wget
        pciutils
      ];

      boot = {
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 10;
          };
          efi.canTouchEfiVariables = true;
        };
        tmp.cleanOnBoot = true;

        # This Zen 5 chip's bus-lock detection fires constantly under
        # Chrome/Proton (tens of thousands of trapped+throttled
        # instructions per minute per journalctl), tanking their
        # performance for a mitigation that mainly matters on
        # multi-tenant hosts, not a single-user desktop.
        kernelParams = [ "split_lock_detect=off" ];
      };

      security = {
        sudo.execWheelOnly = true;
        sudo.keepTerminfo = true;
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
          "docker"
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
