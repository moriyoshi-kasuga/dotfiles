{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.c";
  module = {
    home.packages = with pkgs; [
      gnumake
      cmake
      ninja
    ];
  };
}
