{
  pkgs,
  ...
}:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "catppuccin-mocha-sapphire";
  };

  catppuccin.sddm = {
    enable = true;
    flavor = "mocha";
    accent = "sapphire";
    font = "JetBrains Mono";
    fontSize = "10";
    loginBackground = true;
  };
}
