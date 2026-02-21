{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "haskell";
  module = {
    home.packages = with pkgs; [
      ghc
      haskell-language-server
    ];
  };
}
