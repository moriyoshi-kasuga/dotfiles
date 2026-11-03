_:

{
  flake.modules.homeManager."lang.haskell" =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.ghc ];
      programs.neovim.extraPackages = [ pkgs.haskell-language-server ];
    };
}
