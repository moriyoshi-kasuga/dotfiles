{
  mkModule,
  pkgs,
  ...
}:

mkModule {
  name = "nixos.gui.sddm";
  inheritModule = "nixos.gui";
  nixosModule = {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
    };
    catppuccin.sddm = {
      enable = true;
      flavor = "macchiato";
      accent = "sapphire";
      font = "JetBrains Mono";
      fontSize = "10";
      loginBackground = true;
    };
  };
}
