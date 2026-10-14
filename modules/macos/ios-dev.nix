_:

{
  flake.modules.darwin.ios-dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        xcodegen
        libimobiledevice
        cocoapods
      ];
      homebrew.brews = [ "xcodes" ];
    };
}
