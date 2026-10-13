_:

let
  # vivify は nixpkgs では Linux 向けだけなので、macOS では Homebrew から入れる
  linuxHome =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.vivify ];
    };
in
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        marp-cli
        graphviz
        typst
        poppler-utils
        mo-viewer
      ];
    };

  flake.modules.nixos.base.people.home.imports = [ linuxHome ];

  # homebrew は darwin.pc でだけ有効にしている
  flake.modules.darwin.pc.homebrew = {
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
}
