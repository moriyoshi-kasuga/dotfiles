{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.elm";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      elmPackages.elm
    ];
  };
}
