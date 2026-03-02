{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.go";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      go
    ];
  };
}
