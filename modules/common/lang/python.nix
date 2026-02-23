{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.python";
  homeModule = {
    home.packages = with pkgs; [
      python3
      python3Packages.pip
    ];
  };
}
