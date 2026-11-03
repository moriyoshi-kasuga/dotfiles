_:

{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.typst ];
      programs.neovim.extraPackages = [ pkgs.tinymist ];
    };
}
