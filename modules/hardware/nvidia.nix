_:

{
  flake.modules.nixos.nvidia =
    { pkgs, ... }:
    {
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

        # bus ID はマシンごとに違うので host 側で設定する
        prime.offload = {
          enable = true;
          enableOffloadCmd = true;
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
    };
}
