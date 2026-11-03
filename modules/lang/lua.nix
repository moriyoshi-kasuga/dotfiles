_:

{
  # nvim の設定は lua なので、どの host でも書けるように language server と formatter は base に入れる
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = with pkgs; [
        lua-language-server
        stylua
      ];
    };

  flake.modules.homeManager."lang.lua" =
    { pkgs, ... }:
    {
      # library.libs に入れて、pkg-config と LD_LIBRARY_PATH からも見えるようにする
      library.libs = [ pkgs.lua5_4 ];
      home.packages = [ pkgs.luarocks ];
    };
}
