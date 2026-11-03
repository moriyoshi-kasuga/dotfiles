_:

{
  flake.modules.homeManager."lang.dockerfile" =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = [ pkgs.hadolint ];
    };
}
