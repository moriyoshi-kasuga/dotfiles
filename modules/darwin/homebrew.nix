_:

{
  flake.modules.homeManager."darwin.homebrew" = {
    programs.fish = {
      interactiveShellInit = ''
        /opt/homebrew/bin/brew shellenv | source
      '';
    };
  };

  flake.modules.darwin.homebrew =
    { pkgs, config, ... }:
    {
      homebrew = {
        enable = true;
        user = config.system.primaryUser;
        onActivation = {
          autoUpdate = true;
        };
        casks = [
          "brave-browser"
          "raycast"
          "visual-studio-code"
          "discord"
          "slack"
          "figma"
          "zed"
          "macfuse"
        ];
      };

      environment.systemPackages = with pkgs; [
        xcodegen
        libimobiledevice
        swift
        cocoapods
        xcodes
      ];
    };
}
