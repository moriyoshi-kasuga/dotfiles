_:

{
  flake.modules.homeManager.base =
    { pkgs, lib, ... }:
    {
      home.packages =
        with pkgs;
        [
          marp-cli
          graphviz
          typst
          poppler-utils
          mo-viewer
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.vivify ];
    };

  flake.modules.darwin.base = {
    homebrew = {
      taps = [
        {
          name = "jannis-baum/tap";
          trusted = true;
        }
      ];
      brews = [
        "vivify"
      ];
    };
  };
}
