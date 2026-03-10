{ pkgs, ... }:

{
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = true;
    powerManagement.enable = true;
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

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024; # 32GB in MB
    }
  ];

  boot.kernelModules = [ "nvidia-uvm" ];
  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

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

  services.power-profiles-daemon.enable = true;
  powerManagement.enable = true;
  services = {
    libinput.enable = true;
    upower.enable = true;
    logind.settings.Login = {
      HandlePowerKey = "ignore";
      LidSwitch = "suspend-then-hibernate";
      PowerKey = "hibernate";
      PowerKeyLongPress = "poweroff";
    };
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
