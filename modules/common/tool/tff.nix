_:

{
  flake.modules.homeManager."tool.tff" =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.rustPlatform.buildRustPackage {
          pname = "TaggedFileFlow";
          version = "4.0.0";

          src = pkgs.fetchFromGitHub {
            owner = "moriyoshi-kasuga";
            repo = "TaggedFileFlow";
            rev = "a97e8e05cba6";
            hash = "sha256-zE0Rt0taNZV5amtnA1Z3lMzzVQ/i3xWY9QX2WzYcl58=";
          };

          cargoHash = "sha256-KnByKNhuzT6keUZhD2l+qTRMarbH0n59osazD/TiTNw=";
        })
      ];

      programs.fish.interactiveShellInit = ''
        tff init fish --priority "jkliom" | source
      '';
    };
}
