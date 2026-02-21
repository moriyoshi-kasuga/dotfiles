{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "c";
  module = {
    home.packages = with pkgs; [
      gnumake
      cmake
      ninja
    ];
  };
}
