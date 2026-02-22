{
  pkgs,
  mkModule,
  username,
  homeDirectory,
  ...
}:

mkModule {
  name = "home.base";
  module = {
    programs.home-manager.enable = true;

    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "sapphire";
    };

    home = {
      inherit username homeDirectory;
      stateVersion = "26.05";
    };

    home.packages = [
      pkgs.fastfetch
    ];
  };
}
