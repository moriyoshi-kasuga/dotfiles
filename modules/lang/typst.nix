_:

{
  flake.modules.homeManager."lang.typst" =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.typst ];
      programs.neovim.extraPackages = [ pkgs.tinymist ];
    };
}
