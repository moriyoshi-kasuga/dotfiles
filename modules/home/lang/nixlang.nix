{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "nixlang";
  module = {
    home.packages = with pkgs; [
      nixd
      nixfmt
    ];
  };
}
