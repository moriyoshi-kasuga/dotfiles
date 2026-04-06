{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.lua";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      lua5_4
      luarocks
    ];
  };
}
