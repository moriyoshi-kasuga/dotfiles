{
  mkModule,
  ...
}:

mkModule {
  name = "nixos.gui.basic";
  inheritModule = "nixos.gui";
  nixosModule = {
    catppuccin.cursors.enable = true;
  };
}
