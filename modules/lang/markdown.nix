_:

{
  flake.modules.homeManager."lang.markdown" =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = [ pkgs.rumdl ];
    };
}
