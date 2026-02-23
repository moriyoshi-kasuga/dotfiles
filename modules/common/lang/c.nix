{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.c";
  homeModule = {
    home.packages = with pkgs; [
      gnumake
      cmake
      ninja
    ];
  };
}
