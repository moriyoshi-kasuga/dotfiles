{ pkgs, vars, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = [
    (pkgs.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "Monaspace"
      ];
    })
  ];

  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = vars.system;

  imports = [
    ./dock.nix
    ./finder.nix
  ];
}
