{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.nix";
  module = {
    home.packages = with pkgs; [
      nixd
      nixfmt
    ];
  };
}
