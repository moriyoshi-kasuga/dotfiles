_:

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
}
