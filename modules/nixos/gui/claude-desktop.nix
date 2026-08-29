{ inputs, ... }:

{
  flake.modules.nixos."gui.claude-desktop" =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [ inputs.claude-desktop.overlays.default ];

      environment.systemPackages = [ pkgs.claude-desktop ];

      xdg.mime.defaultApplications = {
        "x-scheme-handler/claude" = [ "com.anthropic.Claude.desktop" ];
      };
    };
}
