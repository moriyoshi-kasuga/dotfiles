{
  mkModule,
  system,
  username,
  homeDirectory,
  pkgs,
  ...
}:

mkModule {
  name = "darwin.base";
  module = {
    fonts.packages = [
      pkgs.nerd-fonts.jetbrains-mono
    ];

    nix = {
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
    nixpkgs.hostPlatform = system;
    system.stateVersion = 6;
    system.primaryUser = username;

    users.users.${username}.home = homeDirectory;
  };
}
