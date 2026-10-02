_:

{
  flake.modules.nixos.amd = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    hardware.amdgpu.initrd.enable = true;
  };
}
