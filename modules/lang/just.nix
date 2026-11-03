_:

{
  flake.modules.homeManager."lang.just" =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.just ];
      programs.neovim.extraPackages = [ pkgs.just-lsp ];
    };
}
