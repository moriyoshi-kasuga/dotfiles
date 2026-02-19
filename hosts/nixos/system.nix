{
  pkgs,
  username,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [
      "usbcore.autosuspend=-1"
      "nvidia_drm.modeset=1"
    ];
    tmp.cleanOnBoot = true;
  };

  networking = {
    hostName = "${username}-NixOS";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ 41641 ];
    };
  };

  time.timeZone = "Asia/Tokyo";

  security = {
    polkit.enable = true;
    sudo.execWheelOnly = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "ja_JP.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services = {
    openssh.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [
        epson-inkjet-printer-workforce-840-series
      ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    tailscale.enable = true;
  };
}
