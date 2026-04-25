{
  mkModule,
  ...
}:

mkModule {
  name = "nixos.bluetooth";
  inheritModule = "nixos";
  nixosModule = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
}
