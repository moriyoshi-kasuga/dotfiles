{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.haskell";
  module = {
    home.packages = with pkgs; [
      ghc
      haskell-language-server
    ];
  };
}
