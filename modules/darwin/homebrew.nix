_:

let
  home = {
    programs.fish = {
      interactiveShellInit = ''
        /opt/homebrew/bin/brew shellenv | source
      '';
    };
  };
in
{
  flake.modules.darwin.pc =
    { config, ... }:
    {
      people.home.imports = [ home ];

      homebrew = {
        enable = true;
        user = config.system.primaryUser;
        onActivation = {
          autoUpdate = true;
          cleanup = "zap";
        };
        casks = [
          "brave-browser"
          "raycast"
          "visual-studio-code"
          "discord"
          "slack"
          "figma"
          "macfuse"
        ];
      };
    };
}
