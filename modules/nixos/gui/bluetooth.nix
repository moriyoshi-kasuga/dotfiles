{
  mkModule,
  ...
}:

mkModule {
  name = "nixos.gui.bluetooth";
  inheritModule = "nixos.gui";
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
