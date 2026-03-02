{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.haskell";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      ghc
      haskell-language-server
    ];
  };
}
