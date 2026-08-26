_:

{
  flake.modules.nixos."gui.amd" = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
