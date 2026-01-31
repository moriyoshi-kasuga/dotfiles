{ pkgs, ... }:

{
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = true;
    # サスペンド・復帰時の安定性を向上
    powerManagement.enable = true;
    # 完全にオフにするのではなく、安定重視の設定
    powerManagement.finegrained = false;

    nvidiaSettings = true;
    modesetting.enable = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };
  services.blueman.enable = true;

  powerManagement.enable = true;
  services = {
    libinput.enable = true;
    upower.enable = true;
    logind.settings.Login.HandlePowerKey = "ignore";
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", DRIVER=="usbhid", TEST=="power/control", ATTR{power/control}="on"
      KERNEL=="event[0-9]*", SUBSYSTEM=="input", TAG+="uaccess"
      SUBSYSTEM=="input", GROUP="input", MODE="0660"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE="0664"
    '';
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    waydroid = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    pulseaudio
    easyeffects
    helvum
    waydroid-helper
  ];
}
