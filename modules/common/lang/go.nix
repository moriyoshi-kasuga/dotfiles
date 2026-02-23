{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.go";
  homeModule = {
    home.packages = with pkgs; [
      go
    ];
  };
}
