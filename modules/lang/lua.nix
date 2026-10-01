_:

{
  flake.modules.homeManager."lang.lua" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        lua5_4
        luarocks
      ];
    };
}
