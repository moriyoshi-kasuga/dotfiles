_:

{
  flake.modules.darwin.ios-dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        xcodegen
        libimobiledevice
        swift
        cocoapods
      ];
      homebrew.brews = [ "xcodes" ];
    };
}
