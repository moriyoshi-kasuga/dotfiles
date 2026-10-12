_:

{
  flake.modules.homeManager."lang.lua" =
    { pkgs, ... }:
    {
      # library.libs に入れて、pkg-config と LD_LIBRARY_PATH からも見えるようにする
      library.libs = [ pkgs.lua5_4 ];
      home.packages = [ pkgs.luarocks ];
    };
}
