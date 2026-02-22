{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.go";
  module = {
    home.packages = with pkgs; [
      go
    ];
  };
}
