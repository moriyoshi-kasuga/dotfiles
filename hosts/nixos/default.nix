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
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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
      wl-clipboard
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

  hardware.nvidia = {
    open = true;
    powerManagement.enable = true; # May require additional configuration
    nvidiaSettings = true;
    modesetting.enable = true;

    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };

  };

  boot.kernelParams = [
    "drm_kms_helper.poll=1" # ホットプラグ検出をポーリングで補う（回避策）
    "usbcore.autosuspend=-1" # USB自動サスペンドを無効化
  ];

  # USB hotplug とHID デバイスのサポートを強化
  services.udev.enable = true;
  services.udev.extraRules = ''
    # すべてのHID入力デバイスの自動サスペンドを無効化
    ACTION=="add", SUBSYSTEM=="usb", DRIVER=="usbhid", TEST=="power/control", ATTR{power/control}="on"
  '';

  hardware.enableAllFirmware = true;
  hardware.enableAllHardware = true;
  services.libinput.enable = true;

  # USB電源管理の設定
  powerManagement.enable = true;
  services.upower.enable = true;
}
