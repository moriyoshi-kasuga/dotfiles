{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.python";
  module = {
    home.packages = with pkgs; [
      python3
      python3Packages.pip
    ];
  };
}
