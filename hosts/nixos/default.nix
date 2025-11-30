{
  config,
  vars,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix

    ./nix.nix
    ./network.nix
    ./region.nix
    ./fonts.nix
    ./virtualisation.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
    enable = true;
    desktopManager.cinnamon.enable = true;
    videoDrivers = [
      # "modesetting"
      "nvidia"
    ];
  };

  # Display Manager configuration
  services.displayManager = {
    defaultSession = "cinnamon";
  };
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.slick.enable = true;
  };

  services.libinput.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${vars.username} = {
    isNormalUser = true;
    description = "${vars.username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "audio"
      "video"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      brave
      wezterm
      discord
      slack
      aseprite
      ldtk
    ];
  };

  programs.zsh.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    alsa-utils
    pulseaudio
    easyeffects
    helvum
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "25.05";

  services.tailscale.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
    # modesetting.enable = true;

    prime = {
      sync.enable = true;
      # offload.enable = true;
      # offload.enableOffloadCmd = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  boot.kernelParams = [
    "usbcore.autosuspend=-1" # USB自動サスペンドを無効化
  ];

  # USB hotplug とHID デバイスのサポートを強化
  services.udev.enable = true;
  services.udev.extraRules = ''
    # すべてのHID入力デバイスの自動サスペンドを無効化
    ACTION=="add", SUBSYSTEM=="usb", DRIVER=="usbhid", TEST=="power/control", ATTR{power/control}="on"

    # 入力デバイスのACL設定
    KERNEL=="event[0-9]*", SUBSYSTEM=="input", TAG+="uaccess"
  '';

  # logind設定でinputデバイスのACLを有効化
  services.logind.settings.Login.HandlePowerKey = "ignore";

  # USB電源管理の設定
  powerManagement.enable = true;
  services.upower.enable = true;
}
