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

  environment.systemPackages = with pkgs; [
    git
  ];

  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = vars.system;

  imports = [
    ./dock.nix
    ./finder.nix
  ];
}
