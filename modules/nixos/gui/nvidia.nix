{
  mkModule,
  pkgs,
  ...
}:

mkModule {
  name = "nixos.gui.nvidia";
  inheritModule = "nixos.gui";
  nixosModule = {
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
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

    boot.initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    hardware.nvidia-container-toolkit.enable = true;
    services.xserver.videoDrivers = [
      "modesetting"
      "nvidia"
    ];
    environment.sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
