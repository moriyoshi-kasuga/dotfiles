{ system, username, ... }:
{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.hostPlatform = system;
  system.stateVersion = 6;
  system.primaryUser = username;
}
