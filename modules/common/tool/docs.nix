_:

{
  flake.modules.homeManager."tool.docs" =
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
