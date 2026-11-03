_:

{
  flake.modules.homeManager."lang.elm" =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = with pkgs; [
        elmPackages.elm-language-server
        elmPackages.elm-format
      ];
    };
}
