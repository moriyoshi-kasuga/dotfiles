_:

{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = [ pkgs.hadolint ];
    };
}
