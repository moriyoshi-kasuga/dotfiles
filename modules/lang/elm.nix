_:

{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = with pkgs; [
        elmPackages.elm-language-server
        elmPackages.elm-format
      ];
    };
}
