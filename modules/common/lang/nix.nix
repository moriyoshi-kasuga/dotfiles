{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.nix";
  homeModule = {
    home.packages = with pkgs; [
      nixd
      nixfmt
    ];
  };
}
