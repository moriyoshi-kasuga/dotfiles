{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "go";
  module = {
    home.packages = with pkgs; [
      go
    ];
  };
}
