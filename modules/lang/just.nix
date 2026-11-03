_:

{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.just ];
      programs.neovim.extraPackages = [ pkgs.just-lsp ];
    };
}
