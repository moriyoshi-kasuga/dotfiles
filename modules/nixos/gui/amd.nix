{
  mkModule,
  ...
}:

mkModule {
  name = "nixos.gui.amd";
  nixosModule = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
