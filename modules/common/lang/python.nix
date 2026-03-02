{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.python";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      python3
      python3Packages.pip
    ];
  };
}
