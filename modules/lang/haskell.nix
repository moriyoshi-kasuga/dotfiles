_:

{
  flake.modules.homeManager."lang.haskell" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ghc
        haskell-language-server
      ];
    };
}
