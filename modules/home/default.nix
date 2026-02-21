{ pkgs, ... }:

{
  username,
  homeDirectory,
}:

{
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

  imports = [
    ./editors
    ./lang
    ./shell
    ./tool
    ./wezterm
  ];
}
