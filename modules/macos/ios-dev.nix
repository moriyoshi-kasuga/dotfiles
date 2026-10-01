_:

{
  flake.modules.darwin.pc =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        xcodegen
        libimobiledevice
        swift
        cocoapods
        xcodes
      ];
    };
}
